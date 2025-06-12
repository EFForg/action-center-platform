class AddVictoryToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :victory, :boolean, default: false
    add_column :action_pages, :victory_message, :text
  end
end
