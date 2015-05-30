class AddArchivedToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :archived, :boolean, default: false
    add_column :action_pages, :redirect_action_page_id, :integer
    add_index :action_pages, :archived
  end
end