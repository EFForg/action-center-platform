namespace :petition do
  desc "Crate petition with signatures"
  task :petition_with_signatures => :environment do
    @action_page = FactoryGirl.create(:petition_complete_with_one_hundred_signatures).action_page
  end
end
