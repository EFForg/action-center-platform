class AddEmailTextToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :email_text, :string
  end
end
