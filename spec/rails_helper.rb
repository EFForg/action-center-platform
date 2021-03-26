# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "spec_helper"
require "rspec/rails"
require "capybara/apparition"

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

apparition_opts = {
  window_size: [1400, 900],
  screen_size: [1920, 1090],
  browser_options: {
    "w3c" => false,
    "args" => ["headless", "disable-gpu", "--window-size=1400,900"]
  }
}

if ENV["TRAVIS"]
  apparition_opts[:browser_options] = {
    "remote-debugging-address" => "127.0.0.1",
    "remote-debugging-port" => 9222
  }
  apparition_opts[:remote] = true
end

Capybara.register_driver :chrome_headless do |app|
  Capybara::Apparition::Driver.new(app, apparition_opts)
end

Capybara.server = :puma
Capybara.javascript_driver = :chrome_headless
Capybara.enable_aria_label = true

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :request
  config.include Warden::Test::Helpers, type: :feature

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = Rails.root.join("spec/fixtures")

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }

  config.before(:each, type: :feature) do
    # disable call tool by default; it will be stubbed for tests that need it
    disable_call_tool
  end

  FileUtils.mkdir_p(Rails.root.join("tmp/cache"))
  config.before(:each) do
    Rails.cache.clear
  end
end

# for request tests
def login(user)
  login_path = "/login"
  post login_path, params: {
    user: {
      email: user.email,
      password: "strong passwords defeat lobsters covering wealth"
    }
  }
end
