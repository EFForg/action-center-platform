require "rails_helper"

RSpec.feature "Congress actions", type: :feature, js: true do
  let!(:action) do
    FactoryGirl.create(:action_page_with_congress_message)
  end
  let!(:members) {
    [FactoryGirl.create(:congress_member,
                        twitter_id: "sisko",
                        state: "CA", bioguide_id: "C000880"),
     FactoryGirl.create(:congress_member, state: "CA", bioguide_id: "A000360")]
  }
  let(:location) {
    OpenStruct.new(success: true,
                   street: "1630 Ravello Drive",
                   city: "Sunnydale",
                   zipcode: 94109,
                   zip4: 1234,
                   state: "CA",
                   district: 10)
  }

  before do
    allow(SmartyStreets).to receive(:get_location).and_return(location)
    stub_request(:post, /retrieve-form-elements/).
      with(body: { "bio_ids" => ["C000880", "A000360"] }).
      and_return(status: 200, body: file_fixture("retrieve-form-elements.json"))
    stub_request(:post, /retrieve-form-elements/).
      with(body: { "bio_ids" => ["", "C000880", "A000360"] }).
      and_return(status: 200, body: file_fixture("retrieve-form-elements.json"))
    stub_request(:post, /fill-out-form/).and_return(status: 200, body: "{}")
  end

  it "allows users to send messages" do
    visit action_page_path(action)
    expect(page).not_to have_content("THANK YOU!")

    # Page 1: Find reps
    fill_in "street_address", with: "1630 Ravello Drive"
    fill_in "zipcode", with: "94109"
    click_on "Find your reps"

    # Page 2: Congress forms info
    fill_in "Your email", with: "test@gmail.com"
    fill_in "Your first name", with: "Jadzia"
    fill_in "Your last name", with: "Dax"
    select "Dr.", from: "Your prefix"
    topic_fields = find_all("select[aria-label='Choose a topic']")
    topic_fields.each { |f| f.find_all("option").last.select_option }
    click_on "Next >"

    # Page 3: send message
    click_on "Submit"
    expect(page).to have_content("THANK YOU!")
  end
end
