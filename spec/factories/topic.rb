FactoryGirl.define do
  factory :topic do
    sequence(:name) { |n| "Vampire#{n}" }
  end
end
