class Institution < ActiveRecord::Base
  require "csv"
  extend FriendlyId

  friendly_id :name, use: %i[slugged history]

  include PgSearch::Model
  pg_search_scope :search,
                  against: %i[
                    name
                    category
                  ],
                  using: { tsearch: { prefix: true } }

  has_many :action_institutions
  has_many :action_pages, through: :action_institutions
  has_many :affiliations

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :category, presence: true

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

  def included_in_active_actions?
    return false if action_pages.empty?

    action_pages.map(&:status).any? "live"
  end
end
