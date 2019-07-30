Given(/^a congress message campaign exists$/) do
  stub_legislators
  @action_page = FactoryGirl.create(:action_page_with_congress_message)
end

When(/^I browse to an embedded action targetting Nancy Pelosi and Kamala Harris$/) do
  visit "/action/#{@action_page.title.downcase.gsub(" ", "-")}/embed_iframe?" + {
    bioguide_ids: ["P000197", "H001075"],
    zip4: "7701",
    zipcode: "94109",
    street: "815 Eddy Street",
    city: "San Francisco",
    state: "CA"
  }.to_param
end

When(/^I fill in the required fields for Nancy Pelosi$/) do
  select("Ms.", from: "$NAME_PREFIX")
  fill_in("$NAME_FIRST", with: "Buffy")
  fill_in("$NAME_LAST", with: "Summers")
  fill_in("$EMAIL", with: "bsummers@ucsunnydale.edu")
  select("Congress", from: "$TOPIC")
end

When(/^I fill in the required fields for Nancy Pelosi and Kamala Harris$/) do
  within("#congressForms-common-fields") {
    fill_in("$NAME_FIRST", with: "Buffy")
    fill_in("$NAME_LAST", with: "Summers")
    fill_in("$EMAIL", with: "bsummers@ucsunnydale.edu")
  }
  within("[data-legislator-id='P000197']") {
    select("Ms.", from: "$NAME_PREFIX")
    select("Congress", from: "$TOPIC")
  }
  within("[data-legislator-id='H001075']") {
    select("Dr.", from: "$NAME_PREFIX")
    fill_in("$PHONE", with: "415-436-9333")
    select("Defense", from: "$TOPIC")
  }
end

When(/^I sign up for the newsletter of the partner with code "(.*?)"$/) do |code|
  find("input[name='#{code}_subscribe']").click
end

Given(/^"(.*?)" is a partner on the action$/) do |name|
  partner = Partner.where(name: name).first
  @action_page.partners << partner
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

Given(/^the petition has 100 signatures with affiliations/) do
  100.times {
    signature = FactoryGirl.create(:signature, petition: @action_page.petition)
    signature.affiliations << FactoryGirl.create(:affiliation, institution: @action_page.institutions.first)
  }
end

Given(/^the local organizing campaign has multiple institutions$/) do
  @action_page.institutions.find_or_create_by(name: "University of Wherever 2")
  @action_page.affiliation_types << AffiliationType.create(name: "Parent")
  @action_page.save
end

When(/^I visit an action page$/) do
  visit "/action/#{@action_page.title.downcase.gsub(" ", "-")}"
end

When(/^I edit the action page$/) do
  visit edit_admin_action_page_path(@action_page)
end

When(/^I input a second affiliation$/) do
  within("#affiliations .nested-fields:nth-child(2)") {
    select("University of Wherever 2", from: "Institution")
    select("Parent", from: "Affiliation type")
  }
end

Then(/^I should receive a CSV file$/) do
  page.response_headers["Content-Type"].should == "application/octet-stream"
  page.response_headers["Content-Disposition"].should == "attachment"
end

When(/^I fill in my name$/) do
  create_visitor
  fill_in "First Name", with: @visitor[:name].split(" ").first
  fill_in "Last Name", with: @visitor[:name].split(" ").last
end

When(/^I fill in my email$/) do
  create_visitor
  fill_in "Email", with: @visitor[:email]
end

When(/^I fill in my zip code$/) do
  create_visitor
  fill_in "signature_zipcode", with: @visitor[:zip_code]
end

When(/^I submit the petition$/) do
  click_button "Speak Out"
end

When(/^I filter the action page by institution$/) do
  @institution = @action_page.institutions.first
  visit "/action/#{@action_page.title.downcase.gsub(" ", "-")}/#{@institution.name.downcase.gsub(" ", "-")}"
end

Then(/^the institution should be selected in the filter$/) do
  find("#select2-_institution_id-container").should have_content(@institution.name)
end

When(/^I stub SmartyStreets$/) do
  stub_smarty_streets
end
