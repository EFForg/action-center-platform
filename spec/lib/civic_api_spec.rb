require "rails_helper"

describe CivicApi do
  before do
    Rails.application.config.google_civic_api_url = "https://civic.example.com"
    Rails.application.secrets.google_civic_api_key = "test-key-for-civic-api"
  end

  let!(:data) do
    {
      "officials" => [{
        "name" => "Sponge Bob",
        "party" => "Sandy Party",
        "emails" => ["spongebob@clarinetfans.annoying"]
      }]
    }
  end
  let(:address) { "815 Eddy St 94109" }

  describe ".state_rep_search" do
    let(:role) { "legislatorUpperBody" }

    it "should get civic_api_url with the correct params" do
      expect(RestClient).to receive(:get) do |url, opts|
        expect(url).to eq("https://civic.example.com")
        expect(opts[:params]).not_to be_nil
        expect(opts[:params][:address]).to eq(address)
        expect(opts[:params][:includeOffices]).to eq(true)
        expect(opts[:params][:levels]).to eq("administrativeArea1")
        expect(opts[:params][:roles]).to eq(role)
        expect(opts[:params][:key]).to eq("test-key-for-civic-api")
      end.and_return(double(body: data.to_json))

      CivicApi.state_rep_search(address, role)
    end

    it "should raise ArgumentError if a required param is missing" do
      allow(RestClient).to receive(:get)

      expect do
        CivicApi.state_rep_search(nil)
      end.to raise_error(ArgumentError)

      expect do
        CivicApi.state_rep_search(nil, role)
      end.to raise_error(ArgumentError)

      expect do
        CivicApi.state_rep_search(address)
      end.to raise_error(ArgumentError)
    end

    it "returns an array of officials" do
      role = CivicApi::VALID_ROLES.first
      stub_request(:any,
                   "https://civic.example.com/?address=815%20Eddy%20St%2094109"\
                   "&includeOffices=true&key=test-key-for-civic-api&"\
                   "levels=administrativeArea1&roles=#{role}")
        .to_return(status: 200, body: data.to_json, headers: {})
      expect(described_class.state_rep_search(address, role)).to \
        eq(data["officials"])
    end
  end

  describe ".all_state_reps_for_role" do
    # Feature not active -- admin front-end planned but not yet implemented
  end
end
