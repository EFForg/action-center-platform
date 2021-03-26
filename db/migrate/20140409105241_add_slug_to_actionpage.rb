class AddSlugToActionpage < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :slug, :string
    add_index :action_pages, :slug
  end
end
