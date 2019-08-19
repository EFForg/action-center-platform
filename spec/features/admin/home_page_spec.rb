require 'rails_helper'

RSpec.feature "UpdateHomepage", type: :feature, js: true do
  before do
    4.times do |i|
      FeaturedActionPage.create weight: i, action_page: FactoryGirl.create(:action_page)
    end
  end

  let!(:tweet) { FactoryGirl.create(:action_page_with_tweet, title: "a tweet") }
  let!(:petition) { FactoryGirl.create(:action_page_with_tweet, title: "a petition") }

  scenario "filter action pages with query" do
    login_as(FactoryGirl.create(:admin_user))

    page.current_window.resize_to(1500, 4000)
    visit(admin_action_pages_path)

    click_on "Featured Actions"

    expect(page).to have_content("Main Item")
    expect(page).to have_content("Featured 3")

    select(tweet.title, from: "Main Item")
    select(petition.title, from: "Featured 3")

    click_on "Save"

    expect(page).to have_content("Featured pages updated")

    expect(FeaturedActionPage.find_by(weight: 0).action_page).to eq(tweet)
    expect(FeaturedActionPage.find_by(weight: 3).action_page).to eq(petition)
  end
end
