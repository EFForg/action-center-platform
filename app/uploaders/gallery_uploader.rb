class GalleryUploader < BaseUploader
  def store_dir
    ["uploads", model.generated_key_part].join("/")
  end
end
