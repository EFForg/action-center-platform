require 'rails_helper'

RSpec.feature "EditTweetFields", type: :feature, js: true do
  let(:action_page) {
    FactoryGirl.create(:tweet).action_page
  }

  scenario "add individual targets" do
    login_as(FactoryGirl.create(:admin_user))

    page.current_window.resize_to(1500, 4000)
    visit(edit_admin_action_page_path(action_page))

    expect(page).to have_content("Edit Action")

    click_on "Action"
    expect(page).to have_content("Type of Action")

    within("[data-action_type=tweet]") do
      fill_in "@", with: "_spock"
      click_on "Add individual"
    end

    within("#action") do
      click_on "Save"
    end

    expect(page).to have_content("Action Page was successfully updated")
    expect(action_page.tweet.targets.map(&:twitter_id)).to include("_spock")
  end
end
