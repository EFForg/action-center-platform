require "rails_helper"

describe CivicApi do
  before do
    Rails.application.config.google_civic_api_url = "http://civic.example.com"
    Rails.application.secrets.google_civic_api_key = "test-key-for-civic-api"
  end

  describe ".state_rep_search" do
    let(:email_campaign) { FactoryGirl.create(:email_campaign, :state_leg) }
    let(:address) { "815 Eddy St 94109" }

    it "should get civic_api_url with the correct params" do
      expect(RestClient).to receive(:get) do |url, opts|
        expect(url).to eq("http://civic.example.com")
        expect(opts[:params]).not_to be_nil
        expect(opts[:params][:address]).to eq("815 Eddy St 94109")
        expect(opts[:params][:includeOffices]).to eq(true)
        expect(opts[:params][:levels]).to eq("administrativeArea1")
        expect(opts[:params][:roles]).to eq("legislatorUpperBody")
        expect(opts[:params][:key]).to eq("test-key-for-civic-api")
      end

      CivicApi.state_rep_search(address, email_campaign.leg_level)
    end

    it "should raise ArgumentError if a required param is missing" do
      allow(RestClient).to receive(:get)

      expect {
        CivicApi.state_rep_search(nil)
      }.to raise_error(ArgumentError)

      expect {
        CivicApi.state_rep_search(nil, email_campaign.leg_level)
      }.to raise_error(ArgumentError)

      expect {
        CivicApi.state_rep_search(address)
      }.to raise_error(ArgumentError)

      expect {
        CivicApi.state_rep_search(address, email_campaign.leg_level)
      }.not_to raise_error
    end
  end

  describe ".all_state_reps_for_role" do
    # Feature not active -- admin front-end planned but not yet implemented
  end
end
