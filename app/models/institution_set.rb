class InstitutionSet < ActiveRecord::Base
  has_many :institutions
  validates :name, :presence => true
end
