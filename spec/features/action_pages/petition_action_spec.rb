require "rails_helper"

RSpec.feature "Petition actions", type: :feature, js: true do
  let!(:action) do
    FactoryGirl.create(:petition).action_page
  end
  let(:location) { OpenStruct.new(city: "Sunnydale", state: "CA") }

  before do
    allow(SmartyStreets).to receive(:get_city_state).and_return(location)
  end

  it "can be signed by visitors" do
    visit action_page_path(action)

    expect(page).not_to have_content("THANK YOU!")
    fill_in "signature_email", with: "test@gmail.com"
    fill_in "signature_first_name", with: "Jadzia"
    fill_in "signature_last_name", with: "Dax"
    fill_in "signature_zipcode", with: "94109"
    click_on "Take action"

    expect(page).to have_content("THANK YOU!")
  end
end
