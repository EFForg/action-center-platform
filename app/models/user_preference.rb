class UserPreference < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true
  validates :value, presence: true
end
