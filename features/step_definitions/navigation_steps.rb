Given (/^I am on "(.*)"$/) do |path|
  visit path
end

When (/^I go to "(.*)"$/) do |path|
  visit path
end

When /^I press "([^\"]*)"$/ do |button|
  click_button(button)
end

When /^I click "([^\"]*)"$/ do |link|
  click_link(link)
end

When /^a new window opens$/ do
  expect(page.driver.browser.window_handles.size).to eq(2)
end

When /^I trigger a click on the element "([^\"]*)"$/ do |selector|
  # Click events sometimes fail to fire when an animation or css transition is in progress.
  find(selector, visible: true).trigger(:click)
end

When /^I click the element "([^\"]*)"$/ do |selector|
  find(selector).click
end

When /^I click the first "([^\"]*)"$/ do |selector|
  first(selector).click
end

When /^I fill in the first "([^\"]*)" with "([^\"]*)"$/ do |field, value|
  first(field).set(value)
end

When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |field, value|
  fill_in(field.gsub(" ", "_"), with: value)
end

When /^I fill in "([^\"]*)" for "([^\"]*)"$/ do |value, field|
  fill_in(field.gsub(" ", "_"), with: value)
end

When /^I fill in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    step %("I fill in "#{name}" with "#{value}")
  end
end

When /^I select "([^\"]*)" from "([^\"]*)"$/ do |value, field|
  select(value, from: field)
end

When /^I select "([^\"]*)" from "([^\"]*)" within "([^\"]*)"$/ do |value, field, container|
  within(container) {
    select(value, from: field)
  }
end

When /^I check "([^\"]*)"$/ do |field|
  check(field)
end

When /^I uncheck "([^\"]*)"$/ do |field|
  uncheck(field)
end

When /^I choose "([^\"]*)"$/ do |field|
  choose(field)
end

When /^I drag "([^\"]+)" onto "([^\"]+)"$/ do |source, target|
  page.find(source).drag_to(page.find(target))
end

Then /^I should see "([^\"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^I should see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)
  page.should have_content(regexp)
end

Then /^I should not see "([^\"]*)"$/ do |text|
  page.should_not have_content(text)
end

Then /^I should not see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)
  page.should_not have_content(regexp)
end

Then /^the "([^\"]*)" field should contain "([^\"]*)"$/ do |field, value|
  find_field(field).value.should =~ /#{value}/
end

Then /^the "([^\"]*)" field should not contain "([^\"]*)"$/ do |field, value|
  find_field(field).value.should_not =~ /#{value}/
end

Then /^the "([^\"]*)" field should contain "([^\"]*)"$/ do |field, value|
  find_field(field).value.should =~ /#{value}/
end

Then /^the "([^\"]*)" checkbox should be checked$/ do |label|
  find_field(label).should be_checked
end

Then /^the "([^\"]*)" checkbox should not be checked$/ do |label|
  find_field(label).should_not be_checked
end

Then(/^"(.*?)" should be selected from "(.*?)"$/) do |value, field|
  selected = false
  find_field(field).all("option[selected]").each do |el|
    if el.text == value
      selected = true
      break
    end
  end
  selected
end

Then(/^I should be on "(.*?)"$/) do |path|
  current_path.should == path
end

Then /^page should have (.+) message "([^\"]*)"$/ do |type, text|
  page.has_css?("p.#{type}", text: text, visible: true)
end

When(/^I reload the page$/) do
  visit current_path
end

When(/^I attach the file "(.*?)" to "(.*?)"$/) do |path, element|
  attach_file(element, path)
end

Then(/^I should see "(.*?)" within "(.*?)"$/) do |text, container|
  find(container).should have_content(text)
end

Then(/^I should see "(.*?)" within the first "(.*?)"$/) do |text, container|
  first(container).should have_content(text)
end

Then(/^I should not see "(.*?)" within "(.*?)"$/) do |text, container|
  find(container).should_not have_content(text)
end

Then(/I should see "(.*?)" within the new window$/) do |text|
  page.within_window(page.windows.last.handle) do
    page.should have_content(text)
  end
end

Then(/^"(.*?)" should be required within "(.*?)"$/) do |name, container|
  within(container) {
    expect(find_field(name)["required"]).to be_truthy
  }
end

Then(/^"(.*?)" should not be required within "(.*?)"$/) do |name, container|
  within(container) {
    expect(find_field(name)["required"]).to be_falsey
  }
end

Then(/^the element "(.*?)" should not exist$/) do |element|
  expect(page).not_to have_selector(element)
end
