class AffiliationType < ActiveRecord::Base
  belongs_to :action_page
  has_many :affiliations
end
