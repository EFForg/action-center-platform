require "rails_helper"

RSpec.feature "Tweet actions", type: :feature, js: true do
  let!(:tweet_action) do
    FactoryGirl.create(:tweet, message: "Default message").action_page
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
  end

  it "allows vistors to tweet at representatives" do
    visit action_page_path(tweet_action)

    expect(page).not_to have_content("THANK YOU!")
    fill_in "street_address", with: "1630 Ravello Drive"
    fill_in "zipcode", with: "94109"
    click_on "Look up your reps"

    expect(page).to have_content("Default message")
    click_on "Tweet @sisko"

    expect(page).to have_content("THANK YOU!")
  end
end
