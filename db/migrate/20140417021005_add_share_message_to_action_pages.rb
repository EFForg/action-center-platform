class AddShareMessageToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :share_message, :string
  end
end
