class Affiliation < ActiveRecord::Base
  belongs_to :action_page
  has_many :signatures
end
