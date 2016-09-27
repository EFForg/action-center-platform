class Institution < ActiveRecord::Base
  require 'csv'
  extend FriendlyId

  friendly_id :name, use: [:slugged, :history]

  has_many :action_institutions
  has_many :action_pages, through: :action_institutions
  has_many :affiliations

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.import(names, action_page)
    names.each do |name|
      institution = self.find_or_create_by!(name: name)
      action_page.institutions << institution
    end

    return true
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
end
