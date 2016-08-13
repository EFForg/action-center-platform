class ActionInstitution < ActiveRecord::Base
  belongs_to :institution
  belongs_to :action_page
end
