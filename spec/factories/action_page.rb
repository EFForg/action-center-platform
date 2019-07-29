FactoryGirl.define do
  factory :action_page do
    title "Sample Action Page"
    summary "not filling in summary"
    description "not filling desc in"
    published true
    email_text "$NAME, thanks for taking action!"
    victory_message "We won"

    trait :with_partner do
      after(:create) do |action_page, evaluator|
        action_page.partners << FactoryGirl.create(:partner)
      end
    end
  end

  factory :action_page_with_petition, parent: :action_page do
    enable_petition true
  end

  factory :action_page_with_tweet, parent: :action_page do
    enable_tweet true
  end

  factory :action_page_with_call, parent: :action_page do
    enable_call true
  end

  factory :action_page_with_email, parent: :action_page do
    enable_email true
  end

  factory :action_page_with_congress_message, parent: :action_page do
    enable_congress_message true
    congress_message_campaign
  end

  factory :archived_action_page, parent: :action_page do
    archived true
    association :active_action_page_for_redirect, factory: :action_page
    victory false
  end

  factory :action_page_with_views, parent: :action_page do
    after(:build) do |action_page, evaluator|
      10.times do |n|
        FactoryGirl.create(:ahoy_view,
                           action_page: action_page,
                           time: Time.zone.now - n.days)
      end
    end
  end
end
