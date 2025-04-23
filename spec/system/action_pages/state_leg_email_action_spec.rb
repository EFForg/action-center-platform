require "rails_helper"

RSpec.describe "State legislator email actions", type: :system, js: true do
  let!(:state_action) do
    FactoryBot.create(:email_campaign, :state_leg).action_page
  end
  let(:data) do
    {
      "officials" => [{
        "name" => "Sponge Bob",
        "party" => "Sandy Party",
        "emails" => ["spongebob@clarinetfans.annoying"]
      }]
    }
  end

  before do
    stub_request(:get, "https://civic.example.com/?address=815%20Eddy%20St%2094109&includeOffices=true&key=test-key-for-civic-api&levels=administrativeArea1&roles=legislatorUpperBody")
      .to_return(status: 200, body: data.to_json, headers: {})
  end

  it "allows vistors to see look up their representatives" do
    visit action_page_path(state_action)
    expect(page).to have_content("Look up your state representatives")

    fill_in "street_address", with: "815 Eddy St"
    fill_in "zipcode", with: "94109"
    click_on "Find your reps"

    expect(page).to have_content("Sponge Bob")
    expect(page).not_to have_content("Thank You!")
  end
end
