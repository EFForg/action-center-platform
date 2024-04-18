require "capybara/rspec"
require "webmock/rspec"
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.around(:each, :run_delayed_jobs) do |example|
    Delayed::Worker.delay_jobs = false
    example.run
    Delayed::Worker.delay_jobs = true
  end

  config.include Capybara::DSL
  config.include FeatureHelpers, type: :feature

  WebMock.disable_net_connect!(allow_localhost: true, allow: "chromedriver.storage.googleapis.com")
end

# Don't prevent form fills by bots during the test run
InvisibleCaptcha.setup do |config|
  config.timestamp_enabled = false
end

# for controller tests
def login_as_admin
  @request.env["devise.mapping"] = Devise.mappings[:admin]
  sign_in FactoryBot.create(:admin_user)
end

def login_as_collaborator
  @request.env["devise.mapping"] = Devise.mappings[:admin]
  sign_in FactoryBot.create(:collaborator_user)
end

def set_weak_password(user)
  weak_password = "12345678"
  user.password = weak_password
  user.password_confirmation = weak_password
  user.save
end

def set_strong_password(user)
  weak_password = "strong passwords defeat lobsters covering wealth"
  user.password = weak_password
  user.password_confirmation = weak_password
  user.save
end
