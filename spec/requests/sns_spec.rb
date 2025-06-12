require "rails_helper"

RSpec.describe "Amazon SNS endpoints", type: :request do
  before(:each) do
    Rails.application.secrets.amazon_authorize_key = "my_amazon_key"
    allow(Sentry).to receive(:capture_message)
  end

  describe "complaint notification" do
    it "logs complaint notifications" do
      headers = { "CONTENT_TYPE" => "application/json" }
      body = File.read("./spec/fixtures/files/sns_complaint.json")
      post "/complaint/#{Rails.application.secrets.amazon_authorize_key}",
           params: body, headers: headers
      expect(response.parsed_body["success"]).to be true
      expect(Complaint.count).to eq 1
      expect(Sentry).to have_received(:capture_message)
    end
  end
end
