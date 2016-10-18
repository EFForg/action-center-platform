class AddCategoryIdToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :category_id, :integer
    remove_column :action_pages, :category
  end
end
