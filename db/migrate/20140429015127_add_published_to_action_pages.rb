class AddPublishedToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :published, :boolean, default: false
  end
end
