class BaseUploader < CarrierWave::Uploader::Base
  storage :fog
  # cache_storage :file

  def default_url(*args)
    "missing.png"
  end

  def store_dir
    [
      model.class.to_s.pluralize.underscore,
      mounted_as.to_s.pluralize,
      id_partition,
      style
    ].join("/")
  end

  # for security; only allow image uploads
  def content_type_allowlist
    [/image\//]
  end

  def style
    version_name || "original"
  end

  def id_partition # mimics paperclips mapping function
    ("%09d" % model.id).scan(/\d{3}/).join("/")
  end
end
