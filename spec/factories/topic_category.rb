FactoryGirl.define do
  factory :topic_category do
    name "Demons"

    after(:create) do |category, evaluator|
      create_list(:topic_set, 2, topic_category: category)
    end
  end
end
