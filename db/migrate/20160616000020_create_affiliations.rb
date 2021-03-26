class CreateAffiliations < ActiveRecord::Migration[5.0]
  def change
    create_table :affiliations do |t|
      t.string :name
      t.references :action_page, index: true, foreign_key: true
      t.timestamps null: false
    end

    change_table :signatures do |t|
      t.references :institution,  index: true
      t.references :affiliation, index: true
    end
  end
end
