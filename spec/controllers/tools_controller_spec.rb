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
    @petition = FactoryGirl.create(:petition_with_99_signatures_needing_1_more)

    post :petition, signature: valid_attributes[:signature].merge({ "petition_id" => @petition.id.to_s })

    expect(@petition.signatures.count).to eq 100
  end

end

def stub_smarty_streets
  stub_resp = {"city"=>"San Francisco", "state_abbreviation"=>"CA", "state"=>"California", "mailable_city"=>true}
  SmartyStreets.stub(:get_city_state).with("94109").and_return(stub_resp)
end
