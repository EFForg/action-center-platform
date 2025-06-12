require "rails_helper"

RSpec.describe ToolsController, type: :controller do
  let(:valid_attributes) do
    {
      signature: {
        "petition_id" => "1",
        "email" => "rob@eff.org",
        "first_name" => "adsf",
        "last_name" => "asdf",
        "zipcode" => "94109",
        "city" => "",
        "country_code" => ""
      }
    }
  end

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
      call_campaign = FactoryBot.create(:call_campaign)

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
    let(:custom_email_campaign) { FactoryBot.create(:email_campaign) }
    let(:state_email_campaign) { FactoryBot.create(:email_campaign, :state_leg) }

    it "should redirect to ActionPage#service_uri(service) if email has custom recipients" do
      service = "gmail"
      uri = "https://composeurl.example.com"
      allow_any_instance_of(EmailCampaign).to receive(:service_uri).with(service).and_return(uri)
      get :email, params: { action_id: custom_email_campaign.action_page.id, service: service }
      expect(response).to redirect_to(uri)
    end

    it "should redirect to ActionPage#service_uri(service, params[:state_rep_email]) if email goes through state legislator lookup" do
      service = "gmail"
      state_rep_email = "state_rep@example.com"
      uri = "https://composeurl.example.com"
      allow_any_instance_of(EmailCampaign).to receive(:service_uri).with(service, { email: state_rep_email }) { uri }
      get :email, params: { action_id: state_email_campaign.action_page.id, state_rep_email: state_rep_email, service: service }
      expect(response).to redirect_to(uri)
    end
  end
end

def create_signature_and_have_user_sign
  @petition = FactoryBot.create(:petition_with_99_signatures_needing_1_more)
  post :petition, params: { signature: valid_attributes[:signature].merge({ "petition_id" => @petition.id.to_s }) }
end

def stub_smarty_streets
  stub_resp = { "city" => "San Francisco", "state_abbreviation" => "CA", "state" => "California", "mailable_city" => true }
  allow(SmartyStreets).to receive(:get_city_state).with("94109").and_return(stub_resp)
end
