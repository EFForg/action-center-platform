FactoryBot.define do
  sequence :signer_email do |n|
    "signer-#{n}@example.com"
  end

  factory :signature do
    first_name { "John" }
    last_name { "Doe" }
    email { generate(:signer_email) }
    country_code { "US" }
    zipcode { "94109" }
    street_address { "815 Eddy St" }
    city { "San Francisco" }
    state { "California" }
    anonymous { false }
  end
end
