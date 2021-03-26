FactoryBot.define do
  factory :topic_set do
    sequence(:tier) { |n| n }

    after(:create) do |set, _evaluator|
      create_list(:topic, 2, topic_set: set)
    end
  end
end
