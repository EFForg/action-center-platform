

Given(/^a petition exists with many signatures$/) do
  @petition = FactoryGirl.create(:petition_complete_with_one_hundred_signatures)
end

When(/^I visit the signatures list$/) do
  visit "/admin/petitions/#{@petition.id}"
end

When(/^I search for an email in the petitions list$/) do
  @matching_signature = @petition.signatures.order(:created_at).last

  find("input[name=query]").set(@matching_signature.email)
  find("input[type=submit][value=Search]").click
end

When(/^I search for an email not in the petitions list$/) do
  find("input[name=query]").set("this filter should not match anything")
  find("input[type=submit][value=Search]").click
end

Then(/^the matching signatures should be in the results$/) do
  expect(page).to have_content(@matching_signature.email)
end

Then(/^there should be no matching signatures$/) do
  expect(page).to have_content("No signatures match this query")
end

When(/^I select some signatures$/) do
  @selected_signature_ids = 4.times.map do
    checkbox = first("input[name=signature_ids\\[\\]]:not(:checked)")
    checkbox.set(true)
    checkbox.value
  end.map(&:to_i)
end

When(/^I click to delete the selected signatures$/) do
  find("input[type=submit][value=Delete\\ Selected]").click
end

Then(/^the selected signatures are destroyed$/) do
  page.has_css?(".container") # this causes capybara to wait until action is complete
  expect(Signature.where(id: @selected_signature_ids)).to be_empty
end

When(/^I click the select all checkbox$/) do
  find("input[type=checkbox].select-all").click
end

Then(/^all signatures are selected$/) do
  expect(first("input[name=signature_ids\\[\\]]:not(:checked)")).to be_nil
end

Then(/^the user "(.*?)" should( not)? be a collaborator$/) do |email, should_not|
  user = User.find_by(email: email)
  expect(user).to be_present
  if should_not
    expect(user).not_to be_collaborator
  else
    expect(user).to be_collaborator
  end
end
