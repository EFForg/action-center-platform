class AddAttachmentBackgroundImageToActionPages < ActiveRecord::Migration[5.0]
  def self.up
    change_table :action_pages do |t|
      t.attachment :background_image
    end
  end

  def self.down
    drop_attached_file :action_pages, :background_image
  end
end
