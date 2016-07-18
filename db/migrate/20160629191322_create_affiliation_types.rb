class CreateAffiliationTypes < ActiveRecord::Migration
  def change
    create_table :affiliation_types do |t|
      t.string :name
      t.references :action_page, index: true
      t.timestamps null: false
    end

    remove_column :affiliations, :action_page_id, :integer, index: true
    remove_column :affiliations, :name, :string
    change_table :affiliations do |t|
      t.references :signature,  index: true
      t.references :institution,  index: true
      t.references :affiliation_type, index: true
    end

    remove_column :signatures, :institution_id, :integer, index: true
    remove_column :signatures, :affiliation_id, :integer, index: true
  end
end