class AddRedirectUrlToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :redirect_url, :string
  end
end
