module ServiceHelpers
  def stub_civicrm
    Rails.application.secrets.supporters["host"] = "https://civicrm.test"
    stub_request(:post, CiviCRM::supporters_api_url).
      to_return(:status => 200, :body => "{}", :headers => {})
  end
end

RSpec.configure do |c|
  c.include ServiceHelpers
end
