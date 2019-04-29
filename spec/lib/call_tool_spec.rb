require "rails_helper"

describe CallTool do
  before do
    Rails.application.config.call_tool_url = "http://call.example.com"
    Rails.application.config.call_api_key = "test-call-power-integration"
  end

  describe ".campaign_call" do
    let(:campaign) { FactoryGirl.create(:call_campaign) }

    let(:keywords) {
      {
        phone: "000-000-0000",
        location: "00000",
        user_id: 456,
        action_id: 789,
        callback_url: "/"
      }
    }

    it "should get call_tool_url/call/create, transforming keyword arguments into params" do
      expect(RestClient).to receive(:get) do |url, opts|
        base_href = Rails.application.config.call_tool_url.sub(/\/$/, "")
        expect(url).to eq("#{base_href}/call/create")
        expect(opts[:params]).not_to be_nil
        expect(opts[:params][:campaignId]).to eq(campaign.to_param)
        expect(opts[:params][:userPhone]).to eq(keywords[:phone])
        expect(opts[:params][:userCountry]).to eq("US")
        expect(opts[:params][:userLocation]).to eq(keywords[:location])
        expect(opts[:params][:callback_url]).to eq(keywords[:callback_url])
        expect(opts[:params][:meta]).to eq({ user_id: keywords[:user_id],
                                             action_id: keywords[:action_id],
                                             action_type: "call" }.to_json)
      end

      CallTool.campaign_call(campaign, **keywords)
    end

    it "should raise ArgumentError if a required param is missing" do
      allow(RestClient).to receive(:get)

      expect {
        CallTool.campaign_call(nil, **keywords)
      }.to raise_error(ArgumentError)

      expect {
        CallTool.campaign_call(campaign, **keywords.dup.tap { |x| x[:phone] = nil })
      }.to raise_error(ArgumentError)

      expect {
        CallTool.campaign_call(campaign, **keywords.dup.tap { |x| x[:location] = nil })
      }.to raise_error(ArgumentError)

      expect {
        CallTool.campaign_call(campaign, **keywords.dup.tap { |x| x[:action_id] = nil })
      }.to raise_error(ArgumentError)

      expect {
        CallTool.campaign_call(campaign, **keywords.dup.tap { |x| x[:callback_url] = nil })
      }.to raise_error(ArgumentError)

      expect {
        CallTool.campaign_call(campaign, **keywords.dup.tap { |x| x[:user_id] = nil })
      }.not_to raise_error
    end

    it "should not raise any errors for twilio 'number invalid' error" do
      exception = RestClient::BadRequest.new
      expect(exception).to receive(:http_body) { %({"error": "13224: number invalid"}) }
      expect(RestClient).to receive(:get).and_raise(exception)

      expect(Raven).not_to receive(:capture_message)
      expect { CallTool.campaign_call(campaign, **keywords) }.not_to raise_exception
    end
  end

  describe ".required_fields_for_campaign" do
    it "should get call_tool_url/api/campaign/:id with the call tool api key" do
      campaign = 12345
      expect(RestClient).to receive(:get) do |url, opts|
        base_href = Rails.application.config.call_tool_url.sub(/\/$/, "")
        expect(url).to eq("#{base_href}/api/campaign/#{campaign}")
        expect(opts[:params][:api_key]).to eq(Rails.application.secrets.call_tool_api_key)
        OpenStruct.new(body: { required_fields: { userLocation: "postal", userPhone: "US" } }.to_json)
      end

      CallTool.required_fields_for_campaign(campaign)
    end
  end

  describe ".campaigns" do
    let(:calltool_campaign) {
      { "id" => 1, "name" => "call someone", "status" => "live" }
    }

    before do
      stub_request(:get, %r{/api/campaign\?api_key(.*)?&page=1}).
        to_return(status: 200, body: { "objects" => [calltool_campaign], "page" => 1, "total_pages" => 1 }.to_json)
    end

    it "should get call_tool_url/api/campaign and return values with id, name, status" do
      list = CallTool.campaigns
      expect(list).to be_an(Array)

      campaign_info = list.first
      expect(campaign_info).to be_a(Hash)
      expect(campaign_info["id"]).to eq(calltool_campaign["id"])
      expect(campaign_info["name"]).to eq(calltool_campaign["name"])
      expect(campaign_info["status"]).to eq(calltool_campaign["status"])
    end
  end
end
