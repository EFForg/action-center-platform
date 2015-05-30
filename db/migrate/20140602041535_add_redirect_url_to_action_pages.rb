class AddRedirectUrlToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :redirect_url, :string
  end
end
