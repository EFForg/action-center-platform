Given(/^a partner named "(.*?)" with the code "(.*?)" exists$/) do |name, code|
  @partner = FactoryGirl.create(:partner, name: name, code: code)
end
