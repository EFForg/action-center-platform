Given(/^A petition exists and show all signatures is enabled$/) do
  @action_page = FactoryGirl.create(:petition_show_all_signatures).action_page

  expect(@action_page.petition.show_all_signatures).to be_truthy
end

When(/^I visit an action page I should see all signatures$/) do
  visit "/action/#{@action_page.title.downcase.gsub(" ", "-")}"
  expect(@action_page.petition.show_all_signatures).to be_truthy
  expect(page).to have_content "All Signatures"
end
