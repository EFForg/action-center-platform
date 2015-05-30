class AddOgImageToActionPages < ActiveRecord::Migration
  def self.up
    change_table :action_pages do |t|
      t.attachment :og_image
    end
  end

  def self.down
    drop_attached_file :action_pages, :og_image
  end
end
