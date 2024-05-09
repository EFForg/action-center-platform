class AffiliationType < ApplicationRecord
  belongs_to :action_page
  has_many :affiliations
end
