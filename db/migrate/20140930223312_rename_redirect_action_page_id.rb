class RenameRedirectActionPageId < ActiveRecord::Migration[5.0]
  def change
  	rename_column :action_pages, :redirect_action_page_id, :archived_redirect_action_page_id
  end
end