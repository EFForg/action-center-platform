require "rails_helper"

describe SourceFile do
  before(:each) do
    @source_file = FactoryGirl.create(:source_file, key: "meh.jpg")
  end

  it "should generate full_urls correctly when amazon_bucket_url is set" do
    bucket_url = ENV["amazon_bucket_url"] = "act.s.eff.org"
    expect(@source_file.full_url).to eq "https://#{bucket_url}/meh.jpg"
  end

  it "should generate full_urls correctly when amazon_bucket_url is not set based on region" do
    ENV["amazon_bucket_url"] = nil
    bucket = ENV["amazon_bucket"] = "actionbucket"
    region = ENV["amazon_region"] = "us-west-1"

    expect(@source_file.full_url).to eq "https://#{bucket}.s3-#{region}.amazonaws.com/meh.jpg"
  end
end
