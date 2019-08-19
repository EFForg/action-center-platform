require 'rails_helper'

RSpec.feature "BasicActionPageFlow", type: :feature, js: true do
  scenario "go through the action page creation flow" do
    login_as(FactoryGirl.create(:admin_user))

    page.current_window.resize_to(1500, 4000)
    visit(new_admin_action_page_path)

    fill_in "Title", with: "Save kittens"
    fill_in_editor "Summary", with: "Save them all"
    fill_in_editor "Description", with: "Save the kitties"

    fill_in "Related Content", with: "https://eff.org"

    click_on "Next"

    expect(page).to have_content("Type of Action")

    expect {
      # Skip other settings
      click_on "Save"

      expect(page).to have_content("This page is not published.")
    }.to change{ ActionPage.count }.by(1)
  end
end
