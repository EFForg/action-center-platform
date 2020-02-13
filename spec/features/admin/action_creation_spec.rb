require "rails_helper"

RSpec.describe "Admin action page creation", type: :feature, js: true do
  before { sign_in_user(FactoryGirl.create(:admin_user)) }
  let!(:category) { FactoryGirl.create(:category, title: "Privacy") }
  it "can create tweet actions" do
    visit new_admin_action_page_path
    fill_in_basic_info(title: "Very Important Action",
                       summary: "A summary",
                       description: "A description")
    click_on "Next"

    select_action_type("tweet")
    fill_in "Message", with: "A message"
    click_on "Next"

    skip_image_selection
    fill_in_social_media
    # Skip partners
    click_on "Next"

    tempermental {
      click_button "Save"
      expect(page).to have_content("Very Important Action", wait: 10)
    }
  end

  it "can create basic petition actions" do
    visit new_admin_action_page_path
    fill_in_basic_info(title: "Very Important Action",
                       summary: "A summary",
                       description: "A description")
    click_on "Next"

    select_action_type("petition")
    fill_in_editor "#action_page_petition_attributes_description",
      with: "A petititon letter"
    fill_in "Goal", with: 1000
    click_on "Next"

    skip_image_selection
    fill_in_social_media
    # Skip partners
    click_on "Next"

    tempermental {
      click_button "Save"
      expect(page).to have_content("Very Important Action", wait: 10)
    }
  end

  it "can create email actions" do
    visit new_admin_action_page_path
    fill_in_basic_info(title: "Very Important Action",
                       summary: "A summary",
                       description: "A description")
    click_on "Next"

    select_action_type("email")
    fill_in "To", with: "test@gmail.com"
    fill_in "Subject", with: "Subject"
    fill_in "Message", with: "An email"
    click_on "Next"

    skip_image_selection
    fill_in_social_media
    # Skip partners
    click_on "Next"

    tempermental {
      click_button "Save"
      expect(page).to have_content("Very Important Action", wait: 10)
    }
  end

  it "can create congress actions" do
    visit new_admin_action_page_path
    fill_in_basic_info(title: "Very Important Action",
                       summary: "A summary",
                       description: "A description")
    click_on "Next"

    select_action_type("congress_message")
    fill_in "Subject", with: "Subject"
    fill_in "Message", with: "A message"
    click_on "Next"

    skip_image_selection
    fill_in_social_media
    # Skip partners
    click_on "Next"

    tempermental {
      click_button "Save"
      expect(page).to have_content("Very Important Action", wait: 10)
    }
  end

  it "can create call actions" do
    visit new_admin_action_page_path
    fill_in_basic_info(title: "Very Important Action",
                       summary: "A summary",
                       description: "A description")
    click_on "Next"

    select_action_type "call"
    fill_in_editor "#action_page_call_campaign_attributes_message",
      with: "Call script"
    click_on "Next"

    skip_image_selection
    fill_in_social_media
    # Skip partners
    click_on "Next"

    tempermental {
      click_button "Save"
      expect(page).to have_content("Very Important Action", wait: 10)
    }
  end

  def fill_in_basic_info(title:, summary:, description:)
    fill_in "Title", with: title
    fill_in_editor "#action_page_summary", with: summary
    fill_in_editor "#action_page_description", with: description
    fill_in_select2 "#action_page_category_id", with: category.title
  end

  def skip_image_selection
    click_on "Next"
    sleep 0.1
    click_on "Next"
    sleep 0.1
  end

  def fill_in_social_media
    fill_in "Share Message", with: "Twitter message"
    fill_in "Title", with: "A social media title"
    click_on "Next"
  end

  def select_action_type(type)
    find("#action_type_#{type}").ancestor("label").click
  end
end
