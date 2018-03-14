class ActionInstitution < ActiveRecord::Base
  belongs_to :institution
  belongs_to :action_page

  # TODO: We should only create one model for each
  # institution/action_page pair, but I don't know what effects that
  # will have on the site.
  # * Check if there are any duplicates in production
  # * If so, remove them in a way that doesn't break anything else
  # * Uncomment the following line
  #validates_uniqueness_of :institution_id, scope: :action_page_id
end
