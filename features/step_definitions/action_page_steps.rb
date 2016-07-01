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

When(/^I visit an action page$/) do
  # visit action_page_path(@action_page)
  visit "/action/#{@action_page.title.downcase.gsub(" ", "-")}"
end

When(/^I edit the action page$/) do
  visit edit_admin_action_page_path(@action_page)
end

Then(/^I should receive a CSV file$/) do
  current_path.should == "/petition/#{@action_page.petition.id}/signatures.csv"
  page.response_headers['Content-Type'].should == "application/octet-stream"
  page.response_headers['Content-Disposition'].should == "attachment"
end
