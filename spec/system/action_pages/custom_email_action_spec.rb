require "rails_helper"

RSpec.describe "Custom email actions", type: :system, js: true do
  let!(:custom_action) do
    FactoryBot.create(:email_campaign).action_page
  end

  it "allows vistors to send emails" do
    visit action_page_path(custom_action)
    expect(page).not_to have_content("Thank You!")
    click_on "Use default mail client"
    expect(page).to have_content("Thank You!")
  end
end
