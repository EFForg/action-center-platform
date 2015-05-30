class AddPhotoUrlToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :photo_url, :string
  end
end
