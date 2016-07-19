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
  @action_page.institutions.find_or_create_by(name: "University of Wherever 2")
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

When(/^I fill in my name$/) do
  create_visitor
  fill_in "First Name", with: @visitor[:name].split(" ").first
  fill_in "Last Name", with: @visitor[:name].split(" ").last
end

When(/^I fill in my email$/) do
  create_visitor
  fill_in "Email", :with => @visitor[:email]
end

When(/^I submit the petition$/) do
  click_button "Speak Out"
  sleep 0.5 while !page.has_content? "Now help spread the word:"
end