module AmazonCredentials
  def amazon_credentials
    {
      :storage => Rails.application.secrets.storage.to_sym,
      :s3_credentials => {
        bucket: Rails.application.secrets.amazon_bucket,
        access_key_id: Rails.application.secrets.amazon_access_key_id,
        secret_access_key: Rails.application.secrets.amazon_secret_access_key
      },
      :s3_host_name => 's3-' + Rails.application.secrets.amazon_region + '.amazonaws.com',
      :s3_protocol => 'https'
    }
  end
end
