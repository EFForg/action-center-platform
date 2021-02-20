class CreateInstitutions < ActiveRecord::Migration[5.0]
  def change
    create_table :institutions do |t|
      t.string :name
      t.references :institution_set, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
