class AddOgTitleToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :og_title, :string
  end
end
