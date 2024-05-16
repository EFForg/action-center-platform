class ActionPageImageUploader < CarrierWave::Uploader::Base
  storage :fog
  # cache_storage :file

  def default_url(*args)
    "missing.png"
  end

  def store_dir
    "#{model.class.to_s.pluralize.underscore}/#{mounted_as.to_s.pluralize}/#{id_partition}/#{style}"
  end

  # we could set this here or config/initializers/carrier_wave.rb
  def asset_host
    Rails.application.secrets.amazon_bucket_url.present? ? "https://#{Rails.application.secrets.amazon_bucket_url}" : super
  end

  private

  def style
    version_name || "original"
  end

  def id_partition # mimics paperclips mapping function
    ("%09d" % model.id).scan(/\d{3}/).join("/")
  end
end
