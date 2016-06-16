class Institution < ActiveRecord::Base
  has_many :action_institutions
  has_many :action_pages, through: :action_institutions
  has_many :signatures
  validates :name, :presence => true
end
