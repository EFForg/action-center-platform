Given(/^a partner named "(.*?)" exists$/) do |name|
  @action_page = FactoryGirl.create(:partner, name: name)
end
