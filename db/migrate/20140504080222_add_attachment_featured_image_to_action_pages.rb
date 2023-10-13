class AddAttachmentFeaturedImageToActionPages < ActiveRecord::Migration[5.0]
  def self.up
    change_table :action_pages do |t|
      t.attachment :featured_image
    end
  end

  def self.down
    drop_attached_file :action_pages, :featured_image
  end
end
