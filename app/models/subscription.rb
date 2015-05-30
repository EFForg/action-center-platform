class Subscription < ActiveRecord::Base
  belongs_to :partner
  validates :email, presence: true, email: true
end
