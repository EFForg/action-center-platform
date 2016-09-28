FactoryGirl.define do
  factory :call_campaign do
    after(:create) do |campaign|
      FactoryGirl.create(:action_page_with_call, call_campaign_id: campaign.id)
    end
  end
end
