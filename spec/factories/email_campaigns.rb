FactoryGirl.define do
  factory :email_campaign do
    after(:create) do |campaign|
      FactoryGirl.create(:action_page_with_email, email_campaign_id: campaign.id)
    end
  end
end
