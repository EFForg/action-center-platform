Given(/^a congress member exists$/) do
  member = FactoryGirl.create(:congress_member)
end

Given(/^a stubbed phantomdc$/) do
  Rails.application.config.congress_forms_url = "http://phantomdc.test"

  proxy.stub(
    "#{Rails.application.config.congress_forms_url}/retrieve-form-elements", method: "post"
  ).and_return(
    Proc.new { |params, headers, body| {
      headers: { "Access-Control-Allow-Origin" => "*" },
      json: {
        :"#{body.last(7)}" => {
          defunct: false,
          contact_url: nil,
          required_actions: [
            { value: "$NAME_FIRST", maxlength: nil, options_hash: nil },
            { value: "$NAME_LAST", maxlength: nil, options_hash: nil },
            { value: "$EMAIL", maxlength: nil, options_hash: nil }
          ]
        }
      }
    } }
  )

  proxy.stub(
    "#{Rails.application.config.congress_forms_url}/fill-out-form", method: "post"
  ).and_return(
    Proc.new { |params, headers, body| {
      headers: { "Access-Control-Allow-Origin" => "*" },
      json: { status: "success" }
    } }
  )
end
