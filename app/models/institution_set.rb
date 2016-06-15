class InstitutionSet < ActiveRecord::Base
  validates :name, :presence => true
end
