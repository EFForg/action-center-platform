class SourceFile < ApplicationRecord
  include Rails.application.routes.url_helpers

  mount_uploader :image, GalleryUploader, mount_on: :file_name
  validates :file_name, presence: true

  before_save :update_image_attributes

  default_scope { order(created_at: :desc) }

  def self.search_by_name(str)
    where("LOWER(file_name) LIKE %?%", sanitize_sql_like(str.downcase))
  end

  def generate_key
    return if key.present?
    self.key = "uploads/#{SecureRandom.uuid}"
  end

  # returns the key with base folder and file name removed
  def generated_key_part
    return "" unless key.present?
    (key.split("/") - ["uploads", file_name]).join("/")
  end

  def key_without_file_name
    return "" unless key.present?
    (key.split("/") - [file_name]).join("/")
  end

  def key_for_carrierwave
    generated_key_part
  end

  def full_url
    image.url
  end

  private

  def update_image_attributes
    if image.present? && file_name_changed?
      self.file_content_type = image.file.content_type
      self.file_size = image.file.size
    end
  end
end
