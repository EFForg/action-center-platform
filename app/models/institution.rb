class Institution < ActiveRecord::Base
  has_many :action_institutions
  has_many :action_pages, through: :action_institutions
  validates :name, :presence => true
end
