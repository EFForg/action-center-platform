FactoryGirl.define do

  factory :action_page do
    title "Sample Action Page"
    summary "not filling in summary"
    description "not filling desc in"
    published true
    email_text "I'm email text I guess..."
    victory_message "We won"
  end

  factory :action_page_with_petition, :parent => :action_page do
    enable_petition true
  end

  factory :action_page_with_tweet, :parent => :action_page do
    enable_tweet true
  end

  factory :action_page_with_call, :parent => :action_page do
    enable_call true
  end

  factory :action_page_with_email, :parent => :action_page do
    enable_email true
  end

  factory :archived_action_page, :parent => :action_page do
    archived true
    association :active_action_page_for_redirect, :factory => :action_page
    victory false
  end

  factory :action_page_with_email, :parent => :action_page do
    enable_email true
  end
end
