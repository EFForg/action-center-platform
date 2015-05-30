class AddWhatToSayToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :what_to_say, :text
  end
end
