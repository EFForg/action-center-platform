require "rails_helper"

RSpec.feature "State legislator email actions", type: :feature, js: true do

  let!(:state_action) do
    FactoryGirl.create(:email_campaign, :state_leg).action_page
  end
  let(:json_parseable_state_officials) { '{"officials": [{"name": "Sponge Bob", "party": "Sandy Party", "emails": ["spongebob@clarinetfans.annoying"]}]}' }

  before do
    Rails.application.config.google_civic_api_url = "http://civic.example.com"
    Rails.application.secrets.google_civic_api_key = "test-key-for-civic-api"

    stub_request(:get, "http://civic.example.com/?address=815%20Eddy%20St%2094109&includeOffices=true&key=test-key-for-civic-api&levels=administrativeArea1&roles=legislatorUpperBody").
         with(headers: { "Accept" => "*/*", "Accept-Encoding" => "gzip, deflate", "Host" => "civic.example.com", "User-Agent" => "rest-client/2.0.2 (linux-gnu x86_64) ruby/2.5.5p157" }).
         to_return(status: 200, body: json_parseable_state_officials, headers: {})
  end

  it "allows vistors to see look up their representatives" do
    visit action_page_path(state_action)
    expect(page).to have_content("Look up your state representatives")

    fill_in "street_address", with: "815 Eddy St"
    fill_in "zipcode", with: "94109"
    click_on "See Your Representatives"

    expect(page).to have_content("Sponge Bob")
    expect(page).not_to have_content("Thank You!")
  end
end
