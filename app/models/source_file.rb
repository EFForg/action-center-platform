require 'aws/s3'
require './lib/amazon_credentials.rb'

class SourceFile < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  # This line can be removed for Rails 4 apps that are using Strong Parameters
  attr_accessible :bucket, :key if S3CorsFileupload.active_record_protected_attributes?

  validates_presence_of :file_name, :file_content_type, :file_size, :key, :bucket

  before_validation(:on => :create) do
    are_we_testing = pull_down_s3_object_attributes

    if are_we_testing  # true if you stub pull_down_s3_object_attributes with true
      self.file_name = key.split('/').last if key
      self.file_size = 10
      self.file_content_type = "image"
    end
  end

  # make all attributes readonly after creating the record (not sure we need this?)
  after_create { readonly! }
  # cleanup; destroy corresponding file on S3
  after_destroy { s3_object.try(:delete) }

  def pull_down_s3_object_attributes
    Rails.logger.debug "Trying to validate S3 object."
    self.file_name = key.split('/').last if key
    self.file_size ||= s3_object.content_length rescue nil
    self.file_content_type ||= s3_object.content_type rescue nil
    false
  end

  def full_url
    # if we have a custom amazon_bucket_url...
    if ENV['amazon_bucket_url']
      "https://#{ENV['amazon_bucket_url']}/#{key}"
    else # we have to build the url up from amazon information
      "https://#{ENV['amazon_bucket']}.#{AmazonCredentials.build_s3_host_name}/#{key}"
    end
  end

  def to_jq_upload
    {
      'id' => id,
      'name' => file_name,
      'size' => file_size,
      'full_url' => full_url,
      'image' => self.is_image?,
      'delete_url' => Rails.application.routes.url_helpers.admin_source_file_path(self, :format => :json)
    }
  end

  def is_image?
    !!file_content_type.try(:match, /image/)
  end

  #---- start S3 related methods -----
  def s3_object
    Rails.logger.debug "Trying to get S3 object."
    s3 = AWS::S3.new(
      :access_key_id => S3CorsFileupload::Config.access_key_id,
      :secret_access_key => S3CorsFileupload::Config.secret_access_key
    )
    bucket = s3.buckets[Rails.application.secrets.amazon_bucket]
    @s3_object = bucket.objects[key]
  rescue
    Rails.logger.debug "Attempt to get S3 object failed."
    nil
  end

  def self.open_aws
    unless @aws_connected
      AWS::S3::Base.establish_connection!(
        :access_key_id     => S3CorsFileupload::Config.access_key_id,
        :secret_access_key => S3CorsFileupload::Config.secret_access_key
      )
    end
    @aws_connected ||= AWS::S3::Base.connected?
  end
  #---- end S3 related methods -----

end
