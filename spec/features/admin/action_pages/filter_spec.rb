require 'rails_helper'

RSpec.feature "FilterActionPages", type: :feature, js: true do
  before do
    FactoryGirl.create(
      :action_page_with_petition,
      title: "borderpetition",
      petition_attributes: {
        description: "border surveillance petition"
      }
    )

    FactoryGirl.create(
      :action_page_with_petition,
      title: "privacypetition",
      petition_attributes: { description: "online privacy petition" }
    )

    FactoryGirl.create(
      :action_page_with_tweet,
      title: "bordertweet",
      tweet_attributes: { message: "border surveillance tweet" }
    )
  end

  scenario "filter action pages with query" do
    login_as(FactoryGirl.create(:admin_user))

    page.current_window.resize_to(1500, 4000)
    visit(admin_action_pages_path)

    expect(page).to have_content("Create new action")

    within :css, "#filter_action_pages" do
      fill_in "q", with: "border surveil"
      click_on "Search"
    end

    expect(page).to have_content("borderpetition")
    expect(page).to have_content("bordertweet")
    expect(page).not_to have_content("privacypetition")
  end
end
