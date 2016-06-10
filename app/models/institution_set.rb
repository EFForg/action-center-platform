class InstitutionSet < ActiveRecord::Base
  has_many :institutions
  has_many :petitions
  validates :name, :presence => true
end
