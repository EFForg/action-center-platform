Given(/^a congress member exists$/) do
  member = FactoryGirl.create(:congress_member)
end

Given(/^a stubbed phantomdc$/) do
  Rails.application.config.congress_forms_url = "http://phantomdc.test"

  stub_request(:post, "#{Rails.application.config.congress_forms_url}/retrieve-form-elements").
    and_return( Proc.new { |request| {
      :headers => { 'Access-Control-Allow-Origin' => '*',
                    'Content-Type' => 'application/json' },
      :body => {
        "#{request.body.last(7)}": {
          defunct: false,
          contact_url: nil,
          required_actions: [
            {value: "$NAME_FIRST", maxlength: nil, options_hash: nil},
            {value: "$NAME_LAST", maxlength: nil, options_hash: nil},
            {value: "$EMAIL", maxlength: nil, options_hash: nil}
          ]
        }
      }.to_json
    }
  })

  stub_request(:post, "#{Rails.application.config.congress_forms_url}/fill-out-form").
    and_return( Proc.new { |request| {
      :headers => { 'Access-Control-Allow-Origin' => '*',
                    'Content-Type' => 'application/json' },
      :body => { status: "success" }.to_json
    }
  })
end
