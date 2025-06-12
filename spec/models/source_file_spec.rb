require "rails_helper"

describe SourceFile do
  before do
    @source_file = FactoryBot.create(:source_file, key: "meh.jpg")
  end

  it "should generate full_urls correctly when amazon_bucket_url is set" do
    begin
      original_bucket_url = Rails.application.secrets.amazon_bucket_url
      bucket_url = Rails.application.secrets.amazon_bucket_url = "https://act.s.eff.org"
      expect(@source_file.full_url).to eq "#{bucket_url}/meh.jpg"
    ensure
      Rails.application.secrets.amazon_bucket_url = original_bucket_url
    end
  end

  it "should generate full_urls correctly when amazon_bucket_url is not set based on region" do
    begin
      original_bucket_url = Rails.application.secrets.amazon_bucket_url
      original_bucket = Rails.application.secrets.amazon_bucket
      original_region = Rails.application.secrets.amazon_region

      Rails.application.secrets.amazon_bucket_url = nil
      bucket = Rails.application.secrets.amazon_bucket = "testbucket"
      region = Rails.application.secrets.amazon_region = "testregion"
      expect(@source_file.full_url).to eq "https://#{bucket}.s3-#{region}.amazonaws.com/meh.jpg"
    ensure
      Rails.application.secrets.amazon_bucket_url = original_bucket_url
      Rails.application.secrets.amazon_bucket = original_bucket
      Rails.application.secrets.amazon_region = original_region
    end
  end
end
