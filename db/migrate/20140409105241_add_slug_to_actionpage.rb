class AddSlugToActionpage < ActiveRecord::Migration
  def change
    add_column :action_pages, :slug, :string
    add_index :action_pages, :slug
  end
end
