FactoryGirl.define do
  factory :congress_member do
    sequence(:bioguide_id) { |n| "A00000#{n}" }
    term_end (Time.now + 1.year).strftime("%Y-%m-%d")
    full_name "Alice Mars"
    first_name "Alice"
    last_name "Mars"
    twitter_id "AliceMars"
    chamber "senate"
    state "CA"
  end
end
