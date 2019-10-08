class ActionInstitution < ActiveRecord::Base
  belongs_to :institution
  belongs_to :action_page

  def self.add(action_page:, category:, reset: false)
    return unless action_page.enable_petition &&
      action_page.petition.enable_affiliations
    action_page.action_institutions.delete_all if reset == "1"
    institutions = Institution.where(category: category) - action_page.institutions
    action_page.institutions << institutions
  end

  # TODO: We should only create one model for each
  # institution/action_page pair, but I don't know what effects that
  # will have on the site.
  # * Check if there are any duplicates in production
  # * If so, remove them in a way that doesn't break anything else
  # * Uncomment the following line
  #validates_uniqueness_of :institution_id, scope: :action_page_id
end
