class Category < ApplicationRecord
  validates :title, presence: true
  validates :title, format: { with: /\A[\w\s&]+\Z/ }
end
