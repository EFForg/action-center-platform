require "rails_helper"
require "carrierwave/test/matchers"

RSpec.describe GalleryUploader do
  include CarrierWave::Test::Matchers

  let(:file_name) { "test-image.png" }
  let(:image_path) { "files/#{file_name}" }
  let(:record) do
    instance_double(SourceFile,
                    file_name: file_name, key_for_carrierwave: "")
  end

  subject { described_class.new(record, :image) }

  before do
  end

  it "uploads to the expected directory" do
    # mock fog with more manual credentials / set the env values
    # and see what we get for store directories
    # should be able to mock the request
  end

  # mocked fog credentials from fixture:
  # default:
  #   aws_access_key_id: 'xxx'     # required
  #   aws_secret_access_key: 'yyy' # required
  #   region: 'us-east-1'          # optional, defaults to 'us-east-1'
  #   amazon_bucket: 'act-test-bucket'
  #   bucket_host: 's3.someprovider.com'
end
