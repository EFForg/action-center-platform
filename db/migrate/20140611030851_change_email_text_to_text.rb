class ChangeEmailTextToText < ActiveRecord::Migration
  def up
    change_column :action_pages, :email_text, :text
  end
  def down
      change_column :action_pages, :email_text, :string
  end
end