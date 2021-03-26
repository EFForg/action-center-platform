require "rails_helper"

RSpec.feature "Tweet actions", type: :feature, js: true do
  let!(:tweet_action) do
    FactoryBot.create(:tweet, message: "Default message").action_page
  end
  let!(:members) do
    [FactoryBot.create(:congress_member,
                       twitter_id: "sisko",
                       state: "CA", bioguide_id: "C000880"),
     FactoryBot.create(:congress_member, state: "CA", bioguide_id: "A000360")]
  end
  let(:location) do
    OpenStruct.new(success: true,
                   street: "1630 Ravello Drive",
                   city: "Sunnydale",
                   zipcode: 94109,
                   zip4: 1234,
                   state: "CA",
                   district: 10)
  end

  before do
    allow(SmartyStreets).to receive(:get_location).and_return(location)
  end

  it "allows vistors to tweet at representatives" do
    visit action_page_path(tweet_action)
    expect(page).not_to have_content("THANK YOU!")
    fill_in "street_address", with: "1630 Ravello Drive"
    fill_in "zipcode", with: "94109"
    click_on "Look up your reps"
    click_on "Tweet @sisko"
    expect(page).to have_content("THANK YOU!")
  end
end
