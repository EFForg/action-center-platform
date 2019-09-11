require "rails_helper"

RSpec.describe "Tests about users", type: :feature do
  before(:each) do
    stub_civicrm
    @user = FactoryGirl.create(:user)
  end

  it "promoted users lose their old password and need a strong one" do
    sign_in_user(@user)

    # Test that we can see that we're at the /account page fine
    expect(page).to have_content("Personal information")

    # log user out
    find("input[value='Logout']", match: :first).click

    #promote user to activist
    @user.admin = true
    @user.save

    # try to login and see prompt to add password
    sign_in_user(@user)
    expect(page).not_to have_content("Personal information")

    # try navigating anywhere else to make sure they can't get around it
    visit "/admin/action_pages"
    expect(page).to have_content("Your account has been flagged for importance")

    # Submit a strong password and move on like an adult
    fill_in "Current Password", with: @user.password
    fill_in "New Password", with: "P1" + @user.password
    fill_in "Confirm New Password", with: "P1" + @user.password
    click_button "Submit"

    # check that the password update nag screen is eliminated
    visit "/account"
    expect(page).to have_content("Personal information")
  end
end
