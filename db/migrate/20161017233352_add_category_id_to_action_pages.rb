class AddCategoryIdToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :category_id, :integer
    remove_column :action_pages, :category
  end
end
