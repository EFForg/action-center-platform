module AmazonCredentials
  # This module is primarily for paperclip config
  def amazon_credentials
    bucket_url_options = {}
    bucket_url_options = {
      s3_host_alias: Rails.application.secrets.amazon_bucket_url,
      url: ":s3_alias_url",
      path: "/:class/:attachment/:id_partition/:style/:filename"
    } unless Rails.application.secrets.amazon_bucket_url.nil?

    {
      storage: Rails.application.secrets.storage.to_sym,
      s3_credentials: {
        bucket: Rails.application.secrets.amazon_bucket,
        access_key_id: Rails.application.secrets.amazon_access_key_id,
        secret_access_key: Rails.application.secrets.amazon_secret_access_key
      },
      s3_region: Rails.application.secrets.amazon_region,
      s3_host_name: build_s3_host_name,
      s3_protocol: "https",
      default_url: ""
    }.merge(bucket_url_options)
  end

  def build_s3_host_name
    AmazonCredentials.build_s3_host_name
  end

  def self.build_s3_host_name
    "s3-" + Rails.application.secrets.amazon_region + ".amazonaws.com"
  end
end
