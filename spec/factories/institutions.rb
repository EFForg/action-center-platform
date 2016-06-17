FactoryGirl.define do
  factory :institution do
    sequence(:name) { |n| "University of Wherever #{n}" }
  end
end
