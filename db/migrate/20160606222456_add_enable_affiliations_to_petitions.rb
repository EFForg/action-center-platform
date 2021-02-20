class AddEnableAffiliationsToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :enable_affiliations, :boolean, default: false
    add_column :petitions, :institution_set_id, :integer
  end
end
