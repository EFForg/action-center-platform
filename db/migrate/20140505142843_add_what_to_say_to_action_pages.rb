class AddWhatToSayToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :what_to_say, :text
  end
end
