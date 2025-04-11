require "rails_helper"

RSpec.describe "Admin accounts", type: :system do
  let!(:user) { FactoryBot.create(:admin_user) }
  before { stub_civicrm }

  it "can sign in" do
    visit "/login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    expect(page).to have_link("Admin", href: "/admin/action_pages")
  end

  it "can sign out" do
    sign_in user
    visit "/"
    find("#nav-modal-toggle").click
    find("input[value='Logout']", visible: :all, match: :first).click
    expect(page).to have_link("Login")
  end
end
