FactoryBot.define do
  factory :email_campaign do
    subject { "hey hey hey" }
    message { "hello world" }

    trait :custom_email do
      email_addresses { "a@example.com, b@example.com" }
    end

    trait :state_leg do
      state { "CA" }
      target_state_upper_chamber { true }
    end

    after(:create) do |campaign|
      FactoryBot.create(:action_page_with_email, email_campaign_id: campaign.id)
    end
  end
end
