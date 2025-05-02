require "rails_helper"

RSpec.describe "Admin action page index", type: :system, js: true do
  before { warden_sign_in(FactoryBot.create(:admin_user)) }

  it "can filter actions" do
    basic = FactoryBot.create(:action_page, title: "Filtered out")
    email_action = FactoryBot.create(:action_page, enable_email: true)

    visit admin_action_pages_path
    find("#action_filters_type").sibling(".select2-container").click
    find("ul#select2-action_filters_type-results li", text: "email").click
    click_on "Search"

    expect(page).to have_content(email_action.title)
    expect(page).not_to have_content(basic.title)
  end
end
