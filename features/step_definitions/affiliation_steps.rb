Given(/^an institution set with the name "(.*?)"$/) do |name|
  @institution_set = FactoryGirl.create(:institution_set, name: name)
end
