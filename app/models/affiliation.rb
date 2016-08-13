class Affiliation < ActiveRecord::Base
  belongs_to :action_page
  belongs_to :signature
  belongs_to :affiliation_type
  belongs_to :institution

  validates :affiliation_type, presence: true
  validates :institution, presence: true
end
