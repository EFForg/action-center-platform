require "rails_helper"

RSpec.describe "Amazon SNS endpoints", :type => :request do

  # describe "bounce notification" do
  #   before(:each) do
  #     @action_page = FactoryGirl.create(:petition_with_99_signatures_needing_1_more).action_page
  #   end
  #
  #   it "lists action pages" do
  #     get "/action"
  #
  #     expect(response).to render_template(:index)
  #     expect(response.body).to include(@action_page.title)
  #   end
  # end
  before(:each) do
    Rails.application.secrets.amazon_authorize_key = 'my_amazon_key'
  end
  
  describe "complaint notification" do
    it "logs complaint notifications" do
      headers = { "CONTENT_TYPE" => "application/json" }
      body = File.read("./spec/fixtures/files/sns_complaint.json")
      post "/complaint/#{Rails.application.secrets.amazon_authorize_key}", body, headers
      expect(JSON.parse(response.body)["success"]).to be_truthy
      expect(Complaint.count).to eq 1
    end

  end
end
