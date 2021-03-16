class Subscription < ActiveRecord::Base
  belongs_to :partner, counter_cache: true
  validates :email, presence: true, email: true
  validates :email, uniqueness: { scope: :partner_id }
end
