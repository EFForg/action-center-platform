Aws.config.update({
    region: Rails.application.secrets.amazon_region,
    credentials: Aws::Credentials.new(Rails.application.secrets.amazon_access_key_id,
                                      Rails.application.secrets.amazon_secret_access_key)
})

S3_BUCKET = Aws::S3::Resource.new.bucket(Rails.application.secrets.amazon_bucket)

