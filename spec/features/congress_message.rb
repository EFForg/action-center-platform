require "rails_helper"

RSpec.feature "Submit congress message", type: :feature do
  let(:action_page) { FactoryGirl.create(:action_page_with_congress_message, :with_partner) }

  let(:partner) { action_page.partners.first }

  let!(:members) {
    [FactoryGirl.create(:congress_member, state: "CA", bioguide_id: "C000880"),
     FactoryGirl.create(:congress_member, state: "CA", bioguide_id: "A000360")]
  }

  let(:location) do
    OpenStruct.new(success: true,
                   street: "The Library",
                   city: "Sunnydale",
                   zipcode: 94109,
                   zip4: 1234,
                   state: "CA",
                   district: 10)
  end

  before do
    stub_civicrm

    allow(SmartyStreets).to receive(:get_location).and_return(location)

    stub_request(:post, /retrieve-form-elements/).
      with(body: { "bio_ids" => ["C000880", "A000360"] }).
      and_return(status: 200, body: file_fixture("retrieve-form-elements.json"))

    stub_request(:post, /fill-out-form/).
      and_return(status: 200, body: "{}")
  end

  scenario "User submits a congress message and subscribes to newletters" do
    visit "/action/#{action_page.title.downcase.gsub(" ", "-")}?partner=#{partner.code}"
    fill_in "street_address", with: "The Library"
    fill_in "zipcode", with: "94109"
    click_button "Submit your message"

    fill_in "common_attributes__NAME_FIRST", with: "Rupert"
    fill_in "common_attributes__NAME_LAST", with: "Giles"
    fill_in "common_attributes__EMAIL", with: "mrgiles@sunnydale.edu"
    check "subscribe"
    check "p1_subscribe"
    select "Mr.", from: "member_attributes_C000880__NAME_PREFIX"
    select "Education, Science & Technology", from: "member_attributes_C000880__TOPIC"
    select "Education", from: "member_attributes_A000360__TOPIC"
    click_button "Submit"

    expect(page).to have_content "Now help spread the word"
    expect(partner.subscriptions.count).to eq 1
    expect(WebMock).to have_requested(:post, CiviCRM::supporters_api_url).
      with(body: hash_including({
        data: '{"contact_params":{"email":"mrgiles@sunnydale.edu","first_name":"Rupert","last_name":"Giles","source":"action center congress message :: Sample Action Page","subscribe":true,"opt_in":true},"address_params":{"city":"Sunnydale","state":null,"street":"The Library","zip":"94109","country":null},"phone":null}'
      }))
  end

  scenario "Logged in user submits a congress message" do
    giles = FactoryGirl.create(:user,
                               first_name: "Rupert",
                               last_name: "Giles",
                               email: "mrgiles@sunnydale.edu")
    sign_in_user(giles)

    visit "/action/#{action_page.title.downcase.gsub(" ", "-")}"
    click_button "Submit your message"

    fill_in "common_attributes__NAME_FIRST", with: "Ripper"
    select "Mr.", from: "member_attributes_C000880__NAME_PREFIX"
    select "Education, Science & Technology", from: "member_attributes_C000880__TOPIC"
    select "Education", from: "member_attributes_A000360__TOPIC"
    click_button "Submit"

    expect(page).to have_content "Now help spread the word"
    expect(giles.reload.first_name).to eq "Ripper"
  end
end
