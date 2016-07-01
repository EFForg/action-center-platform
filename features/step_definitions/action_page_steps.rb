Given(/^a petition exists and show all signatures is enabled$/) do
  @action_page = FactoryGirl.create(:petition_show_all_signatures).action_page
  expect(@action_page.petition.show_all_signatures).to be_truthy
end

Given(/^a petition action exists$/) do
  @action_page = FactoryGirl.create(:petition).action_page
end

Given(/^local affiliations are allowed$/) do
  @action_page.petition.enable_affiliations = true
  @action_page.save
end

Given(/^a local organizing campaign/) do
  @action_page = FactoryGirl.create(:local_organizing_petition).action_page
end

Given(/^the local organizing campaign has multiple institutions$/) do
  @action_page.institutions << Institution.create(name: "University of Wherever 2")
  @action_page.affiliation_types << AffiliationType.create(name: "Parent")
  @action_page.save
end


When(/^I visit an action page$/) do
  # visit action_page_path(@action_page)
  visit "/action/#{@action_page.title.downcase.gsub(" ", "-")}"
end

When(/^I edit the action page$/) do
  visit edit_admin_action_page_path(@action_page)
end

When(/^I input a second affiliation$/) do
  within('#affiliations .nested-fields:nth-child(2)') {
    select("University of Wherever 2", :from => "Institution")
    select("Parent", :from => "Affiliation type")
  }
end

Then(/^I should receive a CSV file$/) do
  current_path.should == "/petition/#{@action_page.petition.id}/signatures.csv"
  page.response_headers['Content-Type'].should == "application/octet-stream"
  page.response_headers['Content-Disposition'].should == "attachment"
end

When(/^I complete the petition$/) do
  create_visitor
  fill_in "First Name", with: @visitor[:name].split(" ").first
  fill_in "Last Name", with: @visitor[:name].split(" ").last
  fill_in "Email", :with => @visitor[:email]
  fill_in "Zip Code", with: "94109"

  RSpec::Mocks.with_temporary_scope do
    stub_smarty_streets
    SmartyStreets.get_city_state("94109")
    click_button "Speak Out"
    # It's important to wait the request to complete before
    # leaving the `with_temporary_scope` block or the stub will disappear
    sleep 0.5 while !page.has_content? "Now help spread the word:"
  end
end
