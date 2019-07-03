FactoryGirl.define do
  factory :congress_message_campaign do
    subject "a subject"
    message "a message"
    campaign_tag "a campaign tag"

    trait :targeting_bioguide_ids do
      target_bioguide_ids "C000880"
    end

    trait :targeting_senate do
      target_house false
    end
  end
end
