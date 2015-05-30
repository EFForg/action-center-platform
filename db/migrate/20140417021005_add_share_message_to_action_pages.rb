class AddShareMessageToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :share_message, :string
  end
end
