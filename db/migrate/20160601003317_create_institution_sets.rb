class CreateInstitutionSets < ActiveRecord::Migration[5.0]
  def change
    create_table :institution_sets do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
