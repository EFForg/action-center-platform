class Institution < ActiveRecord::Base
  require 'csv'

  has_many :action_institutions
  has_many :action_pages, through: :action_institutions
  has_many :affiliations

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.import(file, action_page)
    CSV.foreach(file.path, headers: true) do |row|
      params = row.to_hash
      return false unless params['name']
      institution = self.find_or_create_by!(name: params['name'])
      action_page.institutions << institution
    end

    return true
  end
end
