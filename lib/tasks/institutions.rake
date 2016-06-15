namespace :institution do
  desc "Create a set of institutions"
  task :institution_set => :environment do
    @institution_set = FactoryGirl.create(:institution_set)
  end
end
