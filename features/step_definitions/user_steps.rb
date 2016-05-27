def setup_action
  @action_info = { title: "this is an important call",
    summary: "blablabla",
    description: "such bla, such bla" }
end

def create_visitor
  @visitor ||= { name: "Test User",
    email: "me@example.com",
    password: "strong passwords defeat lobsters covering wealth",
    password_confirmation: "strong passwords defeat lobsters covering wealth" }
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

def create_an_action_page_petition_needing_one_more_signature
  @petition = FactoryGirl.create(:petition_with_99_signatures_needing_1_more)
  @action_page = @petition.action_page
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

def confirm_action_page_new_view_works
  expect(page).to have_content "Protips for your description!"
end

def fill_in_petition_action_inputs
  setup_action
  first(:link, "Content").click # make sure we're in the content section of an action being edited

  # fill in title
  c = @action_info
  find("#action_page_title").set(c[:title])

  find("#epic-action-summary").set(c[:summary])
  find("#epic-action-summary").set(c[:summary])
  # find("#action-page-description").set(c[:description])
  page.execute_script("editor.importFile('new', '#{c[:description]}')")

  first(:link, "Action Settings").click
  find("#action_page_enable_petition").click

  # call tool settings

  find("#action_page_petition_attributes_title").set(c[:title])
  find("#epic-petition-description").set(c[:description])
  find("#action_page_petition_attributes_goal").set('100')

  first(:button, "Save").click
end

Then(/^I get the unpublished petition page$/) do
  c = @action_info
  non_published_msg = "This page is not published."
  expect(page.html).to include(non_published_msg)
  expect(page).to have_content(c[:title])
end


When(/^I create a vanilla action$/) do
  sign_in
  visit '/admin/action_pages'
  loop while first(:link, "Create new action").nil?
  first(:link, "Create new action").click
  confirm_action_page_new_view_works
  fill_in_petition_action_inputs
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
  u.confirm
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

def make_user_activist
  @user.reload
  @user.admin = true
  @user.save
end

When(/^I am made into an activist$/) do
  make_user_activist
end

Then(/^I am prevented from using the app until I supply a strong password$/) do
  sign_in

  # check app is locked down for this user
  expect(page).to have_content("Current Password")
  visit '/admin/action_pages'
  expect(page).to have_content("Current Password")

  # submit strong password
  submit_a_strong_password

  # check lockdown is resolved
  visit '/admin/action_pages'
  expect(page).to have_content("Action Center Admin")
end

def submit_a_strong_password
  fill_in "Current Password", with: @visitor[:password]
  fill_in "New Password", with: "P1" + @visitor[:password]
  fill_in "Confirm New Password", with: "P1" + @visitor[:password]
  click_button "Submit"
end

Given(/^A petition exists that's one signature away from its goal$/) do
  create_an_action_page_petition_needing_one_more_signature
end

When(/^I browse to the action page$/) do
  visit "/action/#{@action_page.title.downcase.gsub(" ", "-")}"
end

def sign_the_petition
  fill_in "First Name", with: @visitor[:name].split(" ").first
  fill_in "Last Name", with: @visitor[:name].split(" ").last
  fill_in "Zip Code", with: "94109"

  # this is how stubbing SmartyStreets looks
  RSpec::Mocks.with_temporary_scope do
    stub_smarty_streets
    SmartyStreets.get_city_state("94109")
    click_button "Speak Out"
    # It's important to wait need to wait for the request to complete before
    # leaving the `with_temporary_scope` block or the stub will disappear
    sleep 0.5 while !page.has_content? "Now help spread the word:"
  end
end

When(/^the action is marked a victory$/) do
  @action_page.update_attributes(victory: true)
end

Then(/^I see a victory message$/) do
  visit "/action/#{@action_page.title.downcase.gsub(" ", "-")}"
  expect(page).to have_content("We won")
end


When(/^I sign a petition that's one signature away from victory$/) do
  visit "/action/#{@action_page.title.downcase.gsub(" ", "-")}"

  # check action progress is shown
  expect(page).to have_content("99 / 100 signatures")

  sign_the_petition
end

Then(/^my signature is acknowledged$/) do
  expect(page).to have_content("Now help spread the word:")
  expect(page).to have_content("100 / 100 signatures")
end


When(/^I click to add an image to the gallery of a new ActionPage$/) do
  # get to a new action_page's view
  visit '/admin/action_pages'
  loop while first(:link, "Create new action").nil?

  first(:link, "Create new action").click

  Capybara.ignore_hidden_elements = false
  loop while first(:link, "Open Gallery").nil?

  first(:link, "Open Gallery").click
  path = "#{Rails.root}/features/upload_files/img.png"
  attach_file("file", path)

  Capybara.ignore_hidden_elements = true

  click_button "Start"
  loop while first(:img, ".preview > a:nth-child(1) > img:nth-child(1)").nil?

  @upload_url = first(:img, ".preview > a:nth-child(1) > img:nth-child(1)")[:src]
  bb_code = "![img.png](#{@upload_url})"

  click_button "Close"

  page.execute_script("editor.importFile('new', 'here is the image #{bb_code}')")
  loop while page.has_content?("img.png - 7.93 KB -")

  first(:button, "Save").click
end


When(/^the image shows up as uploaded over ajax$/) do
  loop until img_node = first(:img, "#description > p:nth-child(1) > img:nth-child(1)")

  uploaded_img_src = first(:img, "#description > p:nth-child(1) > img:nth-child(1)")[:src]

  expect(/^https:\/\/.*act.s.eff.org\/uploads\/.*\/img.png$/).to match uploaded_img_src
end

When(/^I publish the action$/) do
  # click the publish checkbox
  first(:input, "#action_page_published").click
  first(:button, "Save").click
end




Given(/^A tweet petition targeting senate exists$/) do
  setup_action
  @tweet = FactoryGirl.create(:tweet_targeting_senate)
  @action_page = @tweet.action_page
  @action_page.update_attributes(title: @action_info[:title],
    summary: @action_info[:summary],
    description: @action_info[:description])
end

Then(/^I see a button to lookup my reps$/) do
  @lookup_button = first(:button, "Look up your reps")
  expect(@lookup_button).to be_truthy
end

When(/^I fill in my tweet petition location info$/) do
  fill_in "street_address", with: "815 Eddy St"
  fill_in "zipcode", with: "94109"
end


When(/^I click the button to lookup my reps$/) do
  RSpec::Mocks.with_temporary_scope do
    stub_smarty_streets_street_address
    stub_legislator_by_zip

    first(:button, "Look up your reps").click
    sleep 0.5 while !page.has_content? "Your Representatives"
  end

  expect(first(:link, "Tweet @NancyPelosi")).to be_truthy
end


Given(/^my test env has Internet access and I have an S(\d+) key$/) do |arg1|
  pending if this_machine_offline? or ENV['amazon_access_key_id'].nil?
end


def this_machine_offline?
  return $OfflineMode unless $OfflineMode.nil?

  require 'net/http'
  begin
    response = Net::HTTP.get(URI.parse('http://www.example.com/'))
    $OfflineMode = false
  rescue
    $OfflineMode = true
  end

end
