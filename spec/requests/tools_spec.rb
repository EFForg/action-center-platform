require "rails_helper"

RSpec.describe "Tools Controller", type: :request do
  let!(:campaign) { FactoryBot.create(:email_campaign, :state_leg) }
  let!(:action_page) { campaign.action_page }
  let!(:officials) do
    [{
      "name" => "Sponge Bob",
      "party" => "Sandy Party",
      "emails" => ["spongebob@clarinetfans.annoying"]
    }]
  end
  let!(:params) do
    {
      street_address: "815 Eddy St",
      zipcode: "94109",
      email_campaign_id: campaign.id
    }
  end
  let!(:address) { "#{params[:street_address]} #{params[:zipcode]}" }
  let!(:headers) { { "CONTENT_TYPE" => "application/javascript" } }

  describe "POST tools/state_reps" do
    it "returns json containing rep data for a given address" do
      civic_api = class_double("CivicApi")
        .as_stubbed_const(transfer_nested_constants: true)
      allow(civic_api).to receive(:state_rep_search)
        .with(address, campaign.leg_level)
        .and_return(officials)

      post "/tools/state_reps", params: params, xhr: true

      expect(response).to have_http_status(200)
      expect(response.body).to include(officials.first["name"])
    end
  end
end
