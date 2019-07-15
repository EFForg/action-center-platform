def setup_action
  @action_info = { title: "this is an important call",
    summary: "blablabla",
    description: "such bla, such bla" }
end

def create_visitor
  @visitor ||= { name: "Test User",
    email: "me@example.com",
    zip_code: "94117",
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
  visit "/login"
  fill_in "Email", with: @visitor[:email]
  fill_in "Password", with: @visitor[:password]

  click_button "Sign in"
end

def create_an_action_page_petition_needing_one_more_signature
  @petition = FactoryGirl.create(:petition_with_99_signatures_needing_1_more)
  @action_page = @petition.action_page
end

def create_a_call_campaign
  @call_campaign = FactoryGirl.create(:call_campaign, call_campaign_id: senate_call_campaign_id)
  @action_page = @call_campaign.action_page
end

def create_an_email_campaign
  @email_campaign = FactoryGirl.create(:email_campaign)
  @action_page = @email_campaign.action_page
end

Given(/^a user with the email "(.*?)"$/) do |email|
  FactoryGirl.create(:user, email: email)
end

Given(/^an unconfirmed user with the email "(.*?)"$/) do |email|
  FactoryGirl.create(:unconfirmed_user, email: email)
end

Given(/^I exist as an activist$/) do
  create_activist_user
end

Given(/^I am not logged in$/) do
  click_on "Logout"
end

When(/^I sign in with valid credentials$/) do
  sign_in
end

Then(/^I see my account info$/) do
  expect(page.html).to include("Your EFF Action Account")
end

When(/^I return to the site$/) do
  visit "/"
end

Then(/^I should be signed in$/) do
  expect(page).to have_selector 'input[type="submit"][value="Logout"]'
  expect(page).not_to have_content "Sign up"
  expect(page).not_to have_content "Login"
end

When(/^I visit the admin page$/) do
  visit "/admin/action_pages"
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
  import_file_into_editor("new", c[:description])

  first(:link, "Action Settings").click
  find("#action_page_enable_petition").click

  # call tool settings

  find("#action_page_petition_attributes_title").set(c[:title])
  find("#epic-petition-description").set(c[:description])
  find("#action_page_petition_attributes_goal").set("100")

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
  visit "/admin/action_pages"
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
  visit "/account"
end

When(/^I sign out$/) do
  visit "/"
  click_on "Logout"
end

When(/^I click the back button$/) do
  page.evaluate_script("window.history.back()")
end

Then(/^I don't see my information$/) do
  expect(page).not_to have_content(@visitor[:email])
end

When(/^I initiate a password reset request$/) do
  visit "/password/new"

  fill_in "Email", with: @visitor[:email]
  click_button "Send me reset password instructions"
  @reset_token = User.find_by_email(@visitor[:email]).reset_password_token
end

When(/^I change my email address to "(.*?)"$/) do |email|
  @changed_email = email
  visit "/edit"
  fill_in "Email", with: @changed_email
  fill_in "Current password", with: @visitor[:password]
  click_button "Change"
end

When(/^I confirm that I changed my email address$/) do
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
  visit "/logout"
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
  expect(page).to have_content("CURRENT PASSWORD")
  visit "/admin/action_pages"
  expect(page).to have_content("CURRENT PASSWORD")

  # submit strong password
  submit_a_strong_password

  # check lockdown is resolved
  visit "/admin/action_pages"
  expect(page).to have_content("Action Center Admin")
end

def submit_a_strong_password
  fill_in "Current Password", with: @visitor[:password]
  fill_in "New Password", with: "P1" + @visitor[:password]
  fill_in "Confirm New Password", with: "P1" + @visitor[:password]
  click_button "Submit"
end

Given(/^A petition exists thats one signature away from its goal$/) do
  create_an_action_page_petition_needing_one_more_signature
end

Given(/^I browse to the action page with a "(.*?)" newsletter signup$/) do |partner|
  partner_code = Partner.find_by(name: partner).code
  visit "/action/#{@action_page.title.downcase.gsub(" ", "-")}?partner=#{partner_code}"
end

When(/^I browse to the action page$/) do
  visit "/action/#{@action_page.title.downcase.gsub(" ", "-")}"
end

def sign_the_petition
  fill_in "First Name", with: @visitor[:name].split(" ").first
  fill_in "Last Name", with: @visitor[:name].split(" ").last
  find("#signature_zipcode").set("94109")

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

def import_file_into_editor(name, content)
  page.execute_script(
    %($("#action-page-description").data("editor").importFile("#{name}", "#{content}");)
  )
end

When(/^the action is marked a victory$/) do
  @action_page.update_attributes(victory: true)
end

Then(/^I see a victory message$/) do
  visit "/action/#{@action_page.title.downcase.gsub(" ", "-")}"
  expect(page).to have_content("We won")
end

When(/^I sign a petition thats one signature away from victory$/) do
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
  step "I click to open the gallery of a new ActionPage"

  Capybara.ignore_hidden_elements = false
  path = "#{Rails.root}/features/upload_files/img.png"
  attach_file("file", path)
  Capybara.ignore_hidden_elements = true

  click_button "Start"
  loop while first(:img, ".preview > a:nth-child(1) > img:nth-child(1)").nil?

  @upload_url = first(:img, ".preview > a:nth-child(1) > img:nth-child(1)")[:src]
  bb_code = "![img.png](#{@upload_url})"

  click_button "Close"

  import_file_into_editor("new", "here is the image #{bb_code}")

  loop while page.has_content?("img.png - 7.93 KB -")

  first(:button, "Save").click
end

When(/^I click to open the gallery of a new ActionPage$/) do
  # get to a new action_page's view
  visit "/admin/action_pages"
  loop while first(:link, "Create new action").nil?

  first(:link, "Create new action").click
  loop while first(:link, "Open Gallery").nil?

  first(:link, "Open Gallery").click
end

When(/^the image shows up as uploaded over ajax$/) do
  loop until img_node = first(:img, "#description > p:nth-child(1) > img:nth-child(1)")

  uploaded_img_src = first(:img, "#description > p:nth-child(1) > img:nth-child(1)")[:src]

  bucket = Rails.application.secrets.amazon_bucket_url
  expect(/^https:\/\/.*#{bucket}\/uploads\/.*\/img.png$/).to match uploaded_img_src
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
    stub_legislators

    first(:button, "Look up your reps").click
    sleep 0.5 while !page.has_content? "Your Representatives"
  end

  expect(first(:link, "Tweet @NancyPelosi")).to be_truthy
end

Given(/^my test env has Internet access and I have an S(\d+) key$/) do |arg1|
  pending if this_machine_offline? or ENV["amazon_access_key_id"].nil?
end

Given(/^a call petition targeting senate exists$/) do
  setup_action
  @call_campaign = FactoryGirl.create(:call_campaign, call_campaign_id: senate_call_campaign_id, message: "hey hey")
  @action_page = @call_campaign.action_page
  @action_page.update_attributes(title: @action_info[:title],
    summary: @action_info[:summary],
    description: @action_info[:description])
end

Given(/^a call petition targeting a custom number exists$/) do
  setup_action
  @call_campaign = FactoryGirl.create(:call_campaign, call_campaign_id: custom_call_campaign_id, message: "hey hey")
  @action_page = @call_campaign.action_page
  @action_page.update_attributes(title: @action_info[:title],
    summary: @action_info[:summary],
    description: @action_info[:description])
end

Then(/^I see form fields for phone number, address, and zip code$/) do
  expect(page).to have_selector("input[name=inputPhone]")
  expect(page).to have_selector("input[name=inputStreetAddress]")
  expect(page).to have_selector("input[name=inputZip]")
end

Then(/^I see form fields for phone number but not zip code$/) do
  expect(page).to have_selector("input[name=inputPhone]")
  expect(page).not_to have_selector("input[name=inputZip]")
end

When(/^I fill in my phone number, address, and zip code and click call$/) do
  find("input[name=inputPhone]").set("415-555-0100")
  find("input[name=inputStreetAddress]").set("815 Eddy St.")
  find("input[name=inputZip]").set("94109")
  find("button.call-tool-submit").click
  expect(page).to have_css("form[data-success=true]", visible: false)
end

When(/^I fill in my phone number and click call$/) do
  find("input[name=inputPhone]").set("415-555-0100")
  find("button.call-tool-submit").click
end

Then(/^I see instructions for what to say$/) do
  expect(page).to have_selector(".call-body-active", visible: true)
end

def this_machine_offline?
  return $OfflineMode unless $OfflineMode.nil?

  require "net/http"
  begin
    response = Net::HTTP.get(URI.parse("http://www.example.com/"))
    $OfflineMode = false
  rescue
    $OfflineMode = true
  end
end

Given(/^a call campaign exists$/) do
  create_a_call_campaign
end

Given(/^an email campaign exists$/) do
  create_an_email_campaign
end

When(/^I enter the email "(.*?)" and opt for mailings$/) do |email|
  find("input[name=subscription\\[email\\]]").set(email)
  find("input[name=subscribe]").click
end

Then(/^I should see an option to sign up for mailings$/) do
  expect(page).to have_css(".newsletter-signup input[type=checkbox][name=subscribe]")
end

Then(/^"(.*?)" should be signed up for mailings$/) do |email|
  email = email.sub("@", "%40")
  wait_until {
    WebMock::WebMockMatcher.new(:post, CiviCRM::supporters_api_url).matches?(nil)
  }
  WebMock.should have_requested(:post, CiviCRM::supporters_api_url).
    with(body: /.*#{email}.*/)
end

Then(/^I should not have signed up for mailings$/) do
  expect(page).not_to have_css("form[data-signed-up-for-mailings=true]", visible: false)
end

When(/^I click open using gmail$/) do
  click_on "Gmail"
end

Then(/^I should see a sign up form for mailings$/) do
  expect(page).to have_css("form.newsletter-subscription")
end

When(/^I enter the email "(.*?)" and click Sign Up$/) do |email|
  find("input[name=subscription\\[email\\]]").set(email)
  click_on "Sign up"
end

When(/^I wait for the tweet submission to succeed$/) do
  expect(page).to have_selector("input[value='Subscribed!']")
end

Then(/^the email "(.*?)" should go to "(.*?)"$/) do |subject, address|
  email = ActionMailer::Base.deliveries.first
  email.to.should include address
  email.subject.should include subject
end

Then(/^the email "(.*?)" should not go to "(.*?)"$/) do |subject, address|
  emails = ActionMailer::Base.deliveries
  emails.each do |email|
    email.subject.should not_include subject if email.to == address
  end
end

And(/^I follow the password reset link$/) do
  email = ActionMailer::Base.deliveries.first
  reset_link = URI.extract(email.text_part.to_s)[2]
  visit reset_link
end
