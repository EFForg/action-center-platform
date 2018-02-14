FactoryGirl.define do
  factory :subscription do
    first_name "John"
    last_name "Doe"
    sequence(:email) { |n| "signer-#{n}@example.com" }
    partner { |a| a.association :partner }
  end
end
