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
end
