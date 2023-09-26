require "rails_helper"

RSpec.describe "Admin action page creation", type: :feature, js: true do
  before { sign_in_user(FactoryBot.create(:admin_user)) }
  let!(:category) { FactoryBot.create(:category, title: "Privacy") }
  it "can create tweet actions" do
    visit new_admin_action_page_path
    fill_in_basic_info(title: "Very Important Action",
                       summary: "A summary",
                       description: "A description")
    next_section

    select_action_type("tweet")
    fill_in "Message", with: "A message"
    next_section

    # skip banner selection
    next_section

    fill_in_social_media

    tempermental do
      click_button "Save"
      expect(page).to have_content("Very Important Action", wait: 10)
    end
  end

  it "can create basic petition actions" do
    visit new_admin_action_page_path
    fill_in_basic_info(title: "Very Important Action",
                       summary: "A summary",
                       description: "A description")
    next_section

    select_action_type("petition")
    fill_in_editor "#action_page_petition_attributes_description",
                   with: "A petititon letter"
    fill_in "Goal", with: 1000
    next_section

    # skip banner selection
    next_section

    fill_in_social_media

    tempermental do
      click_button "Save"
      expect(page).to have_content("Very Important Action", wait: 10)
    end
  end

  it "can create custom email actions" do
    visit new_admin_action_page_path
    fill_in_basic_info(title: "Very Important Action",
                       summary: "A summary",
                       description: "A description")
    next_section

    select_action_type("email")
    fill_in "Subject", with: "Subject"
    fill_in "Message", with: "An email"
    next_section

    # skip banner selection
    next_section
    fill_in "Or enter custom email addresses below:", with: "test@gmail.com"
    click_on "Next"
    next_section

    fill_in_social_media

    tempermental do
      click_button "Save"
      expect(page).to have_content("Very Important Action", wait: 10)
    end
  end

  it "can create state-level email actions" do
    visit new_admin_action_page_path
    fill_in_basic_info(title: "State-Level Leg Action",
                       summary: "A summary",
                       description: "A description")
    click_on "Next"

    select_action_type("email")
    fill_in "Subject", with: "Subject"
    fill_in "Message", with: "An email"

    select("CA", from: "action_page_email_campaign_attributes_state")
    find("#action_page_email_campaign_attributes_target_state_upper_chamber").ancestor("label").click

    click_on "Next"

    skip_image_selection
    fill_in_social_media
    # Skip partners
    click_on "Next"

    tempermental {
      click_button "Save"
      expect(page).to have_content("State-Level Leg Action", wait: 10)
    }
  end

  it "can create congress actions" do
    visit new_admin_action_page_path
    fill_in_basic_info(title: "Very Important Action",
                       summary: "A summary",
                       description: "A description")
    next_section

    select_action_type("congress_message")
    fill_in "Subject", with: "Subject"
    fill_in "Message", with: "A message"
    next_section

    # skip banner selection
    next_section

    fill_in_social_media

    tempermental do
      click_button "Save"
      expect(page).to have_content("Very Important Action", wait: 10)
    end
  end

  it "can create call actions" do
    visit new_admin_action_page_path
    fill_in_basic_info(title: "Very Important Action",
                       summary: "A summary",
                       description: "A description")
    next_section

    select_action_type "call"
    fill_in_editor "#action_page_call_campaign_attributes_message",
                   with: "Call script"
    next_section

    # skip banner selection
    next_section

    fill_in_social_media

    tempermental do
      click_button "Save"
      expect(page).to have_content("Very Important Action", wait: 10)
    end
  end

  def fill_in_basic_info(title:, summary:, description:)
    fill_in "Title", with: title
    fill_in_editor "#action_page_summary", with: summary
    fill_in_editor "#action_page_description", with: description
    fill_in_select2 "#action_page_category_id", with: category.title
  end

  def next_section
    click_on "Next"
    sleep 0.05
  end

  def fill_in_social_media
    fill_in "Share Message", with: "Twitter message"
    fill_in "Title", with: "A social media title"
    next_section
  end

  def select_action_type(type)
    find("#action_type_#{type}").ancestor("label").click
  end
end
