class AddPublishedToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :published, :boolean, default: false
  end
end
