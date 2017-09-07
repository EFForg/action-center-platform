Given(/^a partner named "(.*?)" exists$/) do |name|
  @partner = FactoryGirl.create(:partner, name: name)
end
