def create_visitor
  @visitor ||= { name: "Test User",
    email: "me@example.com",
    password: "password",
    password_confirmation: "password" }
end

def delete_user
  @user ||= User.find_by_email(@visitor[:email])
  @user.destroy unless @user.nil?
end

def create_activist_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:activist_user, email: @visitor[:email], password: @visitor[:password])
  # @user.confirm!
end

def sign_in
  visit '/login'
  fill_in "Email", :with => @visitor[:email]
  fill_in "Password", :with => @visitor[:password]

  click_button "Sign in"
end

Given(/^I exist as an activist$/) do
  create_activist_user
end

Given(/^I am not logged in$/) do
  visit '/logout'
end

When(/^I sign in with valid credentials$/) do
  create_visitor
  sign_in
end

Then(/^I see a successful sign in message$/) do
  expect(page.html).to include("Hi! You&#39;re signed in!")
end

When(/^I return to the site$/) do
  visit '/'
end

Then(/^I should be signed in$/) do
  expect(page).to have_content "Logout"
  expect(page).not_to have_content "Sign up"
  expect(page).not_to have_content "Login"
end

When(/^I visit the admin page$/) do
  visit '/admin/action_pages'
end

Then(/^I am shown admin controls$/) do
  expect(page).to have_content "Action Center Admin"
end
