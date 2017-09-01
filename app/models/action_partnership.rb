class ActionPartnership < ActiveRecord::Base
  belongs_to :partner
  belongs_to :action_page
end

