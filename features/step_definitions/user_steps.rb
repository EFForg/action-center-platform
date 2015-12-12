def setup_call_action
  @call_action = { title: "this is an important call",
    summary: "blablabla",
    description: "such bla, such bla" }
end

def create_visitor
  @visitor ||= { name: "Test User",
    email: "me@example.com",
    password: "pAssword1",
    password_confirmation: "pAssword1" }
end

def delete_user
  @user ||= User.find_by_email(@visitor[:email])
  @user.destroy unless @user.nil?
end

def create_activist_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:activist_user, email: @visitor[:email], password: @visitor[:password])
end

def create_community_member_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:user, email: @visitor[:email], password: @visitor[:password])
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

When(/^I click to create an action$/) do
  first(:link, "Create new action").click
end

Then(/^I see inputs for a new action_page$/) do
  expect(page).to have_content "Protips for your description!"
end

When(/^I fill in inputs to create a petition action$/) do
  setup_call_action
  # fill in title
  c = @call_action
  find("#action_page_title").set(c[:title])
  # page.execute_script('$(tinymce.editors[0].setContent("my content here"))')

  find("#epic-action-summary").set(c[:summary])
  find("#epic-action-summary").set(c[:summary])
  find("#action-page-description").set(c[:description])
  # editor4.importFile('new', 'heres text')


  first(:link, "Action Settings").click
  find("#action_page_enable_petition").click

  # call tool settings

  find("#action_page_petition_attributes_title").set(c[:title])
  find("#epic-petition-description").set(c[:description])
  find("#action_page_petition_attributes_goal").set('100')


  # Photos
  # first(:link, "Photos").click
  # first(:button, "Select from gallery").click

  # I need to attach the effing file...
  # I can only do this by 'name', and I only have the #file reference
  # so I must edit the dom at this point.
  # or I'll just write it in the markup

  # attach_file(:file, File.join(Rails.root.to_s, 'features', 'upload_files', 'img.png'))
  # first(:button, "Add files...").click

  first(:button, "Save").click
end

Then(/^I get the unpublished petition page$/) do
  c = @call_action
  non_published_msg = "This page is not published."
  expect(page.html).to include(non_published_msg)
  expect(page).to have_content(c[:title])
end




Given(/^I exist as a user$/) do
  create_community_member_user
end

Given(/^I am logged in$/) do
  sign_in
end

When(/^I visit the dashboard$/) do
  visit '/account'
end

When(/^I sign out$/) do
  visit '/logout'
end

When(/^I click the back button$/) do
  page.evaluate_script('window.history.back()')
end

Then(/^I don't see my information$/) do
  expect(page).not_to have_content(@visitor[:email])
end





When(/^I initiate a password reset request$/) do
  visit '/password/new'

  fill_in "Email", :with => @visitor[:email]
  click_button "Send me reset password instructions"
  @reset_token = User.find_by_email(@visitor[:email]).reset_password_token
end

When(/^I change my email address$/) do
  @changed_email = "2" + @visitor[:email]
  visit '/edit'
  fill_in "Email", with: @changed_email
  fill_in "Current password", with: @visitor[:password]
  click_button "Change"

  u = User.find_by_email(@visitor[:email])
  u.confirm!
end

Then(/^I should no longer have a hashed reset token in my user record$/) do
  u = User.find_by_email(@changed_email)
  expect(u.reset_password_token).to be_nil
end

When(/^I log in$/) do
  sign_in
end

When(/^I log out$/) do
  visit '/logout'
end
