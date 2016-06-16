Given(/^A petition exists and show all signatures is enabled$/) do
  @action_page = FactoryGirl.create(:petition_show_all_signatures).action_page
  expect(@action_page.petition.show_all_signatures).to be_truthy
end

When(/^I visit an action page$/) do
  visit "/action/#{@action_page.title.downcase.gsub(" ", "-")}"
  expect(page).to have_content "All Signatures"
end

Then(/^I should receive a CSV file$/) do
  current_path.should == "/petition/#{@action_page.petition.id}/signatures.csv"
  page.response_headers['Content-Type'].should == "application/octet-stream"
  page.response_headers['Content-Disposition'].should == "attachment"
end
