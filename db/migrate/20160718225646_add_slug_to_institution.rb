class AddSlugToInstitution < ActiveRecord::Migration[5.0]
  def change
    add_column :institutions, :slug, :string
    add_index :institutions, :slug, unique: true
  end
end
