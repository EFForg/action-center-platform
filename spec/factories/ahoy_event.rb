FactoryGirl.define do
  factory :ahoy_view, class: Ahoy::Event do
    id { SecureRandom.uuid }
    name "View"
    properties do
      {
        type: "action",
        actionType: "view"
      }
    end
    time Time.zone.now
  end

  factory :ahoy_signature, class: Ahoy::Event do
    id { SecureRandom.uuid }
    name "Action"
    properties do
      {
        type: "action",
        actionType: "signature"
      }
    end
    time Time.zone.now
  end
end
