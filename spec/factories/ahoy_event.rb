FactoryGirl.define do
  factory :ahoy_view, class: Ahoy::Event do
    name "View"
    properties { {
      type: "action",
      actionType: "view"
    } }
    time Time.zone.now
  end

  factory :ahoy_signature, class: Ahoy::Event do
    name "Action"
    properties { {
      type: "action",
      actionType: "signature"
    } }
    time Time.zone.now
  end
end
