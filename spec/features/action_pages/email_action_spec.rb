require "rails_helper"

RSpec.feature "Email actions", type: :feature, js: true do
  let!(:action) do
    FactoryGirl.create(:email_campaign).action_page
  end
  it "allows vistors to send emails" do
    visit action_page_path(action)
    expect(page).not_to have_content("THANK YOU!")
    click_on "Use default mail client"
    expect(page).to have_content("THANK YOU!")
  end
end
