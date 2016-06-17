class CreateActionAllowedInstitutions < ActiveRecord::Migration
  def change
    remove_column :institutions, :institution_set_id, :integer
    remove_column :petitions, :institution_set_id, :integer
    drop_table :institution_sets do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :action_institutions do |t|
      t.belongs_to :action_page, index: true
      t.belongs_to :institution, index: true
      t.timestamps null: false
    end
  end
end
