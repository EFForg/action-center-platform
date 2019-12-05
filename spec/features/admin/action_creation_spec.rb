require "rails_helper"

RSpec.describe "Admin action page creation", type: :feature, js: true do
  before { sign_in_user(FactoryGirl.create(:admin_user)) }
  let!(:category) { FactoryGirl.create(:category, title: "Privacy") }
  it "can create tweet actions" do
    visit new_admin_action_page_path

    fill_in "Title", with: "Tweet Action"
    set_editor("#action_page_summary", "A summary")
    set_editor("#action_page_description", "A description")
    set_select2('#action_page_category_id', category.title)
    click_on "Next"

    select_action_type("tweet")
    fill_in "Message", with: "A message"
    click_on "Next"
    
    # Skip image
    click_on "Next"
    sleep 0.1
    click_on "Next"
    sleep 0.1

    fill_in "Share Message", with: "Tweet at your reps"
    fill_in "Title", with: "A social media title"
    click_on "Next"

    # Skip partners
    click_on "Next"

    click_on "Save"

    expect(page).to have_content("Tweet Action")
  end

  def set_editor(locator, value)
    within_frame find(locator, visible: :all).sibling("div").find("iframe") do
      within_frame find("iframe") do
        find("body").set(value)
      end
    end
  end

  def set_select2(locator, value)
    find(locator).sibling('.select2-container').click
    find('li.select2-results__option[role="treeitem"]', text: value).click
  end

  def select_action_type(type)
    find("#action_type_#{type}").ancestor('label').click
  end
end
