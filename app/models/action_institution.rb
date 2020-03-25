class ActionInstitution < ActiveRecord::Base
  belongs_to :institution
  belongs_to :action_page

  def self.add(action_page:, category:, reset: false)
    return unless action_page.enable_petition &&
      action_page.petition.enable_affiliations
    action_page.action_institutions.delete_all if reset == "1"
    institution_ids = Institution.where(category: category).pluck(:id)
    fast_create(action_page_id: action_page.id, institution_ids: institution_ids)
  end

  def self.fast_create(action_page_id:, institution_ids:)
    insert_params = {
      table: "action_institutions",
      static_columns: {
        action_page_id: action_page_id
      },
      options: {
        timestamps: true,
        check_for_existing: true,
        unique: true
      },
      variable_column: "institution_id",
      values: institution_ids
    }
    FastInserter::Base.new(insert_params).fast_insert
  end

  # TODO: We should only create one model for each
  # institution/action_page pair, but I don't know what effects that
  # will have on the site.
  # * Check if there are any duplicates in production
  # * If so, remove them in a way that doesn't break anything else
  # * Uncomment the following line
  #validates_uniqueness_of :institution_id, scope: :action_page_id
end
