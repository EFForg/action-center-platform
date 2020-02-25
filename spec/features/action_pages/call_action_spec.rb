require "rails_helper"

RSpec.feature "Call actions", type: :feature, js: true do
  let!(:action) do
    FactoryGirl.create(:call_campaign).action_page
  end
  let!(:calltool_request) do
    {
       "objects" => [{ "id" => 1, "name" => "call someone", "status" => "live" }],
       "required_fields" => { "userLocation" => "" },
       "page" => 1,
       "total_pages" => 1
    }.to_json
  end

  before do
    allow(CallTool).to receive(:enabled?).and_return(true)
    stub_request(:get, %r{.*/api/campaign/#{action.call_campaign.call_campaign_id}\?api_key(.*)?})
      .to_return(status: 200, body: calltool_request)
    stub_request(:get, %r{/api/campaign\?api_key(.*)?&page=1})
      .to_return(status: 200, body: calltool_request)
    stub_request(:get, %r{/call/create}).to_return(status: 200)
  end

  it "allows users to call congress" do
    visit action_page_path(action)
    expect(page).not_to have_content("THANK YOU!")

    fill_in "inputPhone", with: "9999999999"
    click_on "Call Now"
    expect(page).to have_content("THANK YOU!")
  end
end
