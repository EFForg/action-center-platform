class Institution < ActiveRecord::Base
  require "csv"
  extend FriendlyId

  friendly_id :name, use: [:slugged, :history]

  include PgSearch
  pg_search_scope :search,
                  against: [
                    :name,
                    :category
                  ],
                  using: { tsearch: { prefix: true } }

  has_many :action_institutions
  has_many :action_pages, through: :action_institutions
  has_many :affiliations

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :category

  def self.process_csv(csv_file)
    [].tap do |names|
      CSV.foreach(csv_file.path, headers: true) do |row|
        row = row.to_hash
        return [] unless row["name"]
        names << row["name"]
      end
    end
  end

  def self.import(category, names)
    names.each do |name|
      find_or_create_by!(name: name, category: category)
    end

    true
  end

  def self.categories
    all.distinct.pluck(:category)
  end

  # Sort institutions by most popular.
  # Put `first` at the top of the list if it exists.
  def self.top(n, first: 0)
    select("institutions.*, COUNT(signatures.id) AS s_count")
      .joins("LEFT OUTER JOIN affiliations ON institutions.id = affiliations.institution_id")
      .joins("LEFT OUTER JOIN signatures ON affiliations.signature_id = signatures.id")
      .group("institutions.id")
      .order("institutions.id = #{first.to_i} desc", "s_count DESC", "institutions.name")
      .limit(n)
  end

  def included_in_active_actions?
    return false if action_pages.empty?
    action_pages.map(&:status).any? "live"
  end
end
