class Affiliation < ActiveRecord::Base
  belongs_to :action_page
  belongs_to :signature
  belongs_to :affiliation_type
  belongs_to :institution
end
