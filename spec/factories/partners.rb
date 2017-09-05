FactoryGirl.define do
  factory :partner do
    name "Another Activist Org"
    sequence(:code) { |n| "p#{n}" }
  end
end
