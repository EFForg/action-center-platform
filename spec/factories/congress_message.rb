FactoryGirl.define do
  form1 = CongressForms::Form.new("C000880", [
            { "value" => "$NAME_FIRST" },
            { "value" => "$NAME_LAST" },
            { "value" => "$ADDRESS_STATE", "options_hash" => {
                "CALIFORNIA" => "CA",
                "NEW YORK" => "NY"
            } }
          ])

  form2 = CongressForms::Form.new("C000881", [
            { "value" => "$ADDRESS_CITY" },
            { "value" => "$ADDRESS_STATE", "options_hash" => {
                "CALIFORNIA" => "CA",
                "NEW YORK" => "NY"
            } }
          ])

  factory :congress_message do
    forms [form1, form2]
  end
end
