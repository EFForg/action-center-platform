class AddOgTitleToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :og_title, :string
  end
end
