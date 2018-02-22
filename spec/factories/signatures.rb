FactoryGirl.define do
  factory :signature do
    first_name "John"
    last_name "Doe"
    sequence(:email) { |n| "signer-#{n}@example.com" }
    country_code "US"
    zipcode "94109"
    street_address "815 Eddy St"
    city "San Francisco"
    state "California"
    anonymous false
  end
end
