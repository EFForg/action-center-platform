require 'spec_helper'

describe "AmazonCredentials" do

  # this test will fail when application.yml changes regarding the amazon configs...
  # not all devs will be using the configs I'm using so it will fail for them...
  # You've got at least something to work with... comment it out if it isn't already...
  it "should never change" do
    s3_host_name = "s3-us-west-1.amazonaws.com"
    extend AmazonCredentials
    expect(amazon_credentials.to_json.length).to eq 235
    expect(amazon_credentials[:s3_host_name]).to eq s3_host_name

    expect(AmazonCredentials.build_s3_host_name).to eq s3_host_name
  end


end
