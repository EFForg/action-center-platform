class AddCategoryToInstitutions < ActiveRecord::Migration[5.0]
  def change
    add_column :institutions, :category, :string
    Institution.update_all(category: "university")
    change_column_null :institutions, :category, false
  end
end
