class AddEnableRedirectToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :enable_redirect, :boolean, :default=>false
  end
end
