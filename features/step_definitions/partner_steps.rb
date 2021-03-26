Given(/^a partner named "(.*?)" with the code "(.*?)" exists$/) do |name, code|
  @partner = FactoryBot.create(:partner, name: name, code: code)
end
