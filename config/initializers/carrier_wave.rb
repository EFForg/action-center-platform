CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     Rails.application.secrets.amazon_access_key_id,                        # required unless using use_iam_profile
    aws_secret_access_key: Rails.application.secrets.amazon_secret_access_key,                        # required unless using use_iam_profile
    # use_iam_profile:      true,                         # optional, defaults to false
    region:                Rails.application.secrets.amazon_region,                  # optional, defaults to 'us-east-1'
    # host:                  's3.example.com',             # optional, defaults to nil
  }

  if ENV["amazon_bucket_url"].present?
    config.fog_credentials[:endpoint] = ENV["amazon_bucket_url"]
  end

  config.fog_directory  = Rails.application.secrets.amazon_bucket                                    # required
  # config.fog_public     = false                                                 # optional, defaults to true
  # config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
  # Use this if you have AWS S3 ACLs disabled.
  # config.fog_attributes = { 'x-amz-acl' => 'bucket-owner-full-control' }
  # Use this if you have Google Cloud Storage uniform bucket-level access enabled.
  # config.fog_attributes = { uniform: true }
  # Use if you use a CDN
  config.asset_host = Rails.application.secrets.amazon_bucket_url if Rails.application.secrets.amazon_bucket_url.present?
  # setting here allows you to setup a local dev env that points to production assets if `amazon_bucket_url` doesnt match the bucket other things will break
  # config.asset_host = Rails.application.secrets.amazon_bucket_url.present? ? "https://#{Rails.application.secrets.amazon_bucket_url}" : nil
  # For an application which utilizes multiple servers but does not need caches persisted across requests,
  # uncomment the line :file instead of the default :storage.  Otherwise, it will use AWS as the temp cache store.
  config.cache_storage = :file
end
