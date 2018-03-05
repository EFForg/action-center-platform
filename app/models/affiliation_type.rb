class AffiliationType < ActiveRecord::Base
  belongs_to :action_page, touch: true
  has_many :affiliations
end
