require 'rails_helper'

RSpec.describe ToolsController, type: :controller do

  let(:valid_attributes) { {
    signature: {
      "petition_id"=>"1",
      "email"=>"rob@eff.org",
      "first_name"=>"adsf",
      "last_name"=>"asdf",
      "zipcode"=>"94109",
      "city"=>"",
      "country_code"=>""
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

end

def create_signature_and_have_user_sign
  @petition = FactoryGirl.create(:petition_with_99_signatures_needing_1_more)
  allow_any_instance_of(ToolsController).to receive(:update_congress_scorecards).and_return(nil)
  post :petition, signature: valid_attributes[:signature].merge({ "petition_id" => @petition.id.to_s })
end

def stub_smarty_streets
  stub_resp = {"city"=>"San Francisco", "state_abbreviation"=>"CA", "state"=>"California", "mailable_city"=>true}
  allow(SmartyStreets).to receive(:get_city_state).with("94109").and_return(stub_resp)
end
