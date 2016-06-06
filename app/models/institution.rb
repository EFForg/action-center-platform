class Institution < ActiveRecord::Base
  belongs_to :institution_set
  validates :name, :presence => true
end
