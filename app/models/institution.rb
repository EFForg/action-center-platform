class Institution < ActiveRecord::Base
  has_many :action_institutions
  has_many :action_pages, through: :action_institutions
  has_many :signatures
  validates_presence_of :name
  validates_uniqueness_of :name
end
