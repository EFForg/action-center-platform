class AddEnableRedirectToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :enable_redirect, :boolean, :default=>false
  end
end
