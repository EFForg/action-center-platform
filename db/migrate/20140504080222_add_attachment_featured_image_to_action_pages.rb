class AddAttachmentFeaturedImageToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :featured_image_file_name, :string
    add_column :action_pages, :featured_image_content_type, :string
    add_column :action_pages, :featured_image_file_size, :bigint
    add_column :action_pages, :featured_image_updated_at, :datetime
  end
end
