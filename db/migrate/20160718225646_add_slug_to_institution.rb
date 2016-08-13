class AddSlugToInstitution < ActiveRecord::Migration
  def change
    add_column :institutions, :slug, :string
    add_index :institutions, :slug, unique: true
  end
end
