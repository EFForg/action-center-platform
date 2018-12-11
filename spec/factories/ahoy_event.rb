FactoryGirl.define do
  factory :ahoy_view, class: Ahoy::Event do
    name "View"
    properties '{type: "action", actionType: "view"}'
    time Time.now
  end
end
