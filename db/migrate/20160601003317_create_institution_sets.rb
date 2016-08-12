class CreateInstitutionSets < ActiveRecord::Migration
  def change
    create_table :institution_sets do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
