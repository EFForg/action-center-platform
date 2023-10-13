class AddPhotoUrlToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :photo_url, :string
  end
end
