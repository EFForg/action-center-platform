require "rails_helper"

RSpec.describe ToolsController, type: :controller do
  let(:valid_attributes) { {
    signature: {
      "petition_id" => "1",
      "email" => "rob@eff.org",
      "first_name" => "adsf",
      "last_name" => "asdf",
      "zipcode" => "94109",
      "city" => "",
      "country_code" => ""
    }
  } }

  before(:each) do
    stub_smarty_streets
  end

  it "should create signatures when a user signs" do
    create_signature_and_have_user_sign

    sig = @petition.signatures.last

    expect(sig.city).to eq "San Francisco"
    expect(sig.state).to eq "California"
    expect(@petition.signatures.count).to eq 100
  end

  # this is a tricky one... there's some coupling in the javascript layer as
  # well as in the controllers
  it "should still work if SmartyStreets credentials aren't hooked up" do
    # we want to raise an exception if we get into SmartyStreets at all
    # with a nil SmartyStreets API an alt code path is followed
    allow(SmartyStreets).to receive(:get_city_state).with("94109").and_raise("should not have wandered into SmartyStreets")
    Rails.application.secrets.smarty_streets_id = nil

    create_signature_and_have_user_sign
    sig = @petition.signatures.last
    expect(sig.city).to eq ""
    expect(sig.state).to eq ""
    expect(sig.zipcode).to eq valid_attributes[:signature]["zipcode"]
    expect(@petition.signatures.count).to eq 100
  end

  describe "#call" do
    it "should CallTool#campaign_call, passing parameters in" do
      call_campaign = FactoryGirl.create(:call_campaign)

      expect(CallTool).to receive(:campaign_call)
      post :call, params: {
             phone: "000-000-0000",
             location: "00000",
             call_campaign_id: call_campaign.id,
             action_id: call_campaign.action_page.id
           }
    end
  end

  describe "#email" do
    let(:custom_email_campaign) { FactoryGirl.create(:email_campaign, :custom_email) }
    let(:state_email_campaign) { FactoryGirl.create(:email_campaign, :state_leg) }

    it "should redirect to ActionPage#service_uri(service) if email has custom recipients" do
      service, uri = "gmail", "https://composeurl.example.com"
      expect(ActionPage).to receive(:find_by_id) { custom_email_campaign.action_page }
      expect(custom_email_campaign).to receive(:service_uri).with(service) { uri }
      get :email, params: { action_id: custom_email_campaign.action_page.id, service: service }
      expect(response).to redirect_to(uri)
    end

    it "should redirect to ActionPage#service_uri(service, params[:state_rep_email]) if email goes through state legislator lookup" do
      service, state_rep_email, uri = "gmail", "state_rep@example.com", "https://composeurl.example.com"
      expect(ActionPage).to receive(:find_by_id) { state_email_campaign.action_page }
      expect(state_email_campaign).to receive(:service_uri).with(service, { email: state_rep_email }) { uri }
      get :email, params: { action_id: state_email_campaign.action_page.id, state_rep_email: state_rep_email, service: service }
      expect(response).to redirect_to(uri)
    end
  end

  describe "#state_reps" do
    let(:email_campaign) { FactoryGirl.create(:email_campaign, :state_leg) }
    let(:address) { "815 Eddy St 94109" }
    let(:json_parseable_state_officials) { '{"officials": [{"name": "Sponge Bob", "party": "Sandy Party", "emails": ["spongebob@clarinetfans.annoying"]}]}' }

    before do
      Rails.application.config.google_civic_api_url = "http://civic.example.com"
      Rails.application.secrets.google_civic_api_key = "test-key-for-civic-api"

      stub_request(:get, "http://civic.example.com/?address=%20&includeOffices=true&key=test-key-for-civic-api&levels=administrativeArea1&roles=legislatorUpperBody").
         with(headers: { "Accept" => "*/*", "Accept-Encoding" => "gzip, deflate", "Host" => "civic.example.com", "User-Agent" => "rest-client/2.0.2 (linux-gnu x86_64) ruby/2.5.5p157" }).
         to_return(status: 200, body: json_parseable_state_officials, headers: {})
    end

    it "should render JSON with the state officials array" do
      get :state_reps, params: { email_campaign_id: email_campaign.action_page.email_campaign_id }

      expect(response).to have_http_status(200)
    end
  end
end

def create_signature_and_have_user_sign
  @petition = FactoryGirl.create(:petition_with_99_signatures_needing_1_more)
  post :petition, params: { signature: valid_attributes[:signature].merge({ "petition_id" => @petition.id.to_s }) }
end

def stub_smarty_streets
  stub_resp = { "city" => "San Francisco", "state_abbreviation" => "CA", "state" => "California", "mailable_city" => true }
  allow(SmartyStreets).to receive(:get_city_state).with("94109").and_return(stub_resp)
end
