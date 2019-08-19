require 'rails_helper'

RSpec.feature "EditCongressMessageFields", type: :feature, js: true do
  let(:action_page) {
    FactoryGirl.create(
      :action_page_with_congress_message
    ).tap do |ap|
      ap.congress_message_campaign.update(
        target_house: true,
        target_senate: true,
        target_bioguide_ids: nil
      )
    end
  }

  before {
    FactoryGirl.create(:congress_member,
                       full_name: "Kim Cretak",
                       bioguide_id: "C01")
    FactoryGirl.create(:congress_member,
                       full_name: "Jim Neral",
                       bioguide_id: "N02"
                      )
  }

  scenario "edit the congress message campaign" do
    login_as(FactoryGirl.create(:admin_user))

    page.current_window.resize_to(1500, 4000)
    visit(edit_admin_action_page_path(action_page))

    expect(page).to have_content("Edit Action")

    click_on "Action"
    expect(page).to have_content("Type of Action")

    within("[data-action_type=congress_message]") do
      expect(find("[id$=_target_house]")).to be_checked
      expect(find("[id$=_target_senate]")).to be_checked
      expect(find("[id$=_target_specific_legislators]")).not_to be_checked

      find(:label, "Specific Legislators").click

      expect(find("[id$=_target_house]")).not_to be_checked
      expect(find("[id$=_target_senate]")).not_to be_checked
      expect(find("[id$=_target_specific_legislators]")).to be_checked

      select2 "Target bioguide list", "Kim Cretak"
    end

    within("#action") do
      click_on "Save"
    end

    expect(page).to have_content("Action Page was successfully updated")
    expect(action_page.congress_message_campaign.reload.target_bioguide_ids).to eq("C01")
  end
end
