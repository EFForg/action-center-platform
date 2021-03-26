class Category < ActiveRecord::Base
  validates :title, presence: true
  validates :title, format: { with: /\A[\w\s&]+\Z/ }
end
