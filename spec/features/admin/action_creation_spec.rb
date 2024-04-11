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

    skip_banner_selection
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

    skip_banner_selection
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
    fill_in "Or enter custom email addresses below:", with: "test@gmail.com"
    next_section

    skip_banner_selection
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

    skip_banner_selection
    fill_in_social_media

    tempermental do
      click_button "Save"
      expect(page).to have_content("State-Level Leg Action", wait: 10)
    end
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

    skip_banner_selection
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

    skip_banner_selection
    fill_in_social_media

    tempermental do
      click_button "Save"
      expect(page).to have_content("Very Important Action", wait: 10)
    end
  end

  it "can add images" do
    stub_request(:get, %r{uploads/featured-image.png}).to_return(status: 200, body: fixture_file_upload("test-image.png", "image/png").tempfile.to_io, headers: {})
    stub_request(:any, %r{/action_pages/featured_images/000/000/([0-9]+)/original/featured-image.png}).to_return(status: 200, body: "", headers: {})
    stub_request(:get, %r{uploads/og-image.png}).to_return(status: 200, body: fixture_file_upload("test-image.png", "image/png").tempfile.to_io, headers: {})
    stub_request(:any, %r{/action_pages/og_images/000/000/([0-9]+)/original/og-image.png}).to_return(status: 200, body: "", headers: {})
    FactoryBot.create(:source_file, key: "uploads/featured-image.png", file_name: "featured-image.png")
    FactoryBot.create(:source_file, key: "uploads/og-image.png", file_name: "og-image.png")
    visit new_admin_action_page_path
    fill_in_basic_info(title: "Very Important Action",
                       summary: "A summary",
                       description: "A description")
    next_section

    select_action_type("tweet")
    fill_in "Message", with: "A message"
    next_section

    expect(page).to have_selector("#images", visible: true, wait: 5)
    click_on "featured-image.png"
    next_section

    expect(page).to have_selector("#sharing", visible: true, wait: 5)
    fill_in "Share Message", with: "Twitter message"
    fill_in "Title", with: "A social media title"
    click_on "og-image.png"
    next_section

    tempermental do
      click_button "Save"
      expect(page).to have_content("Very Important Action", wait: 10)
    end

    # save_and_open_page
    # expect(page).to have_xpath("//img[contains(@src,'missing')]")
    expect(page).to have_xpath("//img[contains(@src,'featured-image.png')]")
    expect(page).to have_xpath("//meta[contains(@content,'og-image.png')]", visible: false)
  end

  def fill_in_basic_info(title:, summary:, description:)
    fill_in "Title", with: title
    fill_in_editor "#action_page_summary", with: summary
    fill_in_editor "#action_page_description", with: description
    select(category.title, from: "action_page_category_id") #we should use the label to find the select but the label here is not correctly pointing to the select
  end

  def next_section
    click_on "Next"
    sleep 0.05
  end

  def skip_banner_selection
    expect(page).to have_selector("#images", visible: true, wait: 5)
    next_section
  end

  def fill_in_social_media
    expect(page).to have_selector("#sharing", visible: true, wait: 5)
    fill_in "Share Message", with: "Twitter message"
    fill_in "Title", with: "A social media title"
    next_section
  end

  def select_action_type(type)
    find("#action_type_#{type}").ancestor("label").click
  end
end
