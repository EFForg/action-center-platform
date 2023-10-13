class AddFieldsForToolsToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :enable_call, :boolean, default: false
    add_column :action_pages, :enable_petition, :boolean, default: false
    add_column :action_pages, :enable_email, :boolean, default: false
    add_column :action_pages, :enable_share, :boolean, default: false
  end
end
