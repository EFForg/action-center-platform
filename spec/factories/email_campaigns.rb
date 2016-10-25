FactoryGirl.define do
  factory :email_campaign do
    email_addresses "a@example.com, b@example.com"
    subject "a subject"
    message "a message"

    after(:create) do |campaign|
      FactoryGirl.create(:action_page_with_email, email_campaign_id: campaign.id)
    end
  end

  factory :email_campaign_with_custom_target, parent: :email_campaign do
    target_senate false
    target_house false
    target_email true

    email_addresses "a@example.com"
  end
end
