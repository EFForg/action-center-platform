class AddEmailTextToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :email_text, :string
  end
end
