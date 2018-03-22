module ServiceHelpers
  def stub_civicrm
    Rails.application.secrets.supporters["host"] = "https://civicrm.test"
    stub_request(:post, CiviCRM::supporters_api_url).
      and_return(status: 200, body: "{}", headers: {})

    stub_request(:post, CiviCRM::supporters_api_url).
      with(body: /generate_checksum/).
      and_return(status: 200, body: { checksum: "xyz" }.to_json, headers: {})
  end
end

RSpec.configure do |c|
  c.include ServiceHelpers
end

World(ServiceHelpers) if respond_to?(:World) #cucumber
