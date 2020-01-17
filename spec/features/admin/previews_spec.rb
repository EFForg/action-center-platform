require "rails_helper"

RSpec.describe "Admin action page previews", type: :feature, js: true do
  before { sign_in_user(FactoryGirl.create(:admin_user)) }

  xit "works for tweet actions" do
    # window switching is broken, fixing previews for now
    tweet = FactoryGirl.create(:tweet)
    action = FactoryGirl.create(:action_page_with_tweet, tweet: tweet)
    visit edit_admin_action_page_path(action)
    fill_in "Title", with: "New title"
    click_on "Action"
    fill_in "Message", with: "New message"
    click_on "Preview"
    sleep 0.1
    page.driver.switch_to_window page.driver.window_handles.last
    expect(page).to have_content("New title")
    expect(page).to have_content("New message")
  end
end
