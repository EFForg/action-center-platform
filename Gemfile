source "https://rubygems.org"

gem "rails", "~> 5.0"

#Database
gem "pg", "~> 1.1"
gem "pg_search"

# Hosting-related
gem "aws-sdk", "~> 2.3"
gem "aws-sdk-rails", "~> 1"
gem "dotenv-rails", "~> 2"
gem "rack-attack", "~> 5"
gem "rails_12factor", group: :production # Loads "rails_serve_static_assets" and "rails_stdout_logging"
gem "rails_response_headers", "~> 0"

# Frontend/assets
gem "bootstrap-daterangepicker-rails", "~> 3"
gem "bootstrap-sass", "~> 3.4"
gem "bourbon", "~> 3"
gem "bundler", ">= 1.8.4" # needed for rails-assets
gem "fontello_rails_converter", "~> 0"
gem "react-rails", "~> 1"
gem "redcarpet", "~> 3" # Markdown
gem "sass-rails", "~> 5.0"
gem "select2-rails"               # Autocomplete select menus
gem "uglifier", ">= 1.3.0"        # compressor for JavaScript assets
gem "webshims-rails", "~> 1"
source "https://rails-assets.org" do
  gem "rails-assets-chartjs", "~> 2"
  gem "rails-assets-congress-images-102x125"
  gem "rails-assets-EpicEditor", "~> 0"
  gem "rails-assets-html5shiv", "3.7.2"
  gem "rails-assets-ionicons", "~> 2"
  gem "rails-assets-jquery", "2.1.3"
  gem "rails-assets-jquery-cookie", "~> 1"
  gem "rails-assets-jquery-timeago", "~> 1"
  gem "rails-assets-jquery-ujs", "1.0.3"
  gem "rails-assets-lodash", "3.7.0"
  gem "rails-assets-moment", "2.9.0"
  gem "rails-assets-respond", "~> 1"
  gem "rails-assets-roboto-webfont", "~> 0"
  gem "rails-assets-sweetalert", "1.0.1"
end

# File upload
gem "paperclip", "~> 5.2"

# Email preformatting
gem "nokogiri", "~> 1"                    # Required for premailer-rails
gem "premailer-rails", "~> 1"             # Inline styles for emails

# Optimization
gem "sprockets-image_compressor", "~> 0" # Optimizes png/jpg

# Analytics
gem "ahoy_matey", "~> 1.6" # Analytics
gem "chartkick", "~> 3"
gem "eff_matomo", "~> 0.2.4", require: "matomo"
gem "groupdate", "~> 2"

# Job queue
gem "daemons", "~> 1"
gem "delayed_job_active_record", "~> 4"

# Exception monitoring
gem "sentry-raven", "~> 0.15"

# Fancy counter caches
gem "counter_culture", "~> 2.0"

# Other
gem "activerecord-session_store", "~> 1"
gem "acts_as_paranoid", git: "https://github.com/ActsAsParanoid/acts_as_paranoid.git"
gem "cocoon", "~> 1"                      # Dynamically add and remove nested associations from forms
gem "descriptive_statistics", "~> 2"      # Used for calculating percentiles
gem "devise", "~> 4.7"
gem "ejs", "~> 1"                         # Embedded javascript
gem "email_validator", "~> 1"
gem "fastly", "~> 2"
gem "friendly_id", "~> 5.0" # Slugging/permalink plugins for Active Record
gem "going_postal", "~> 0"                # Zip code validation
gem "gravatar-ultimate", "~> 2"
gem "http_accept_language", "~> 2"        # Detect HTTP language header
gem "invisible_captcha", "~> 0"           # Prevent form submissions by bots
gem "iso_country_codes", "~> 0"
gem "jbuilder", "~> 1.2" # JSON APIs
gem "oauth", "~> 0"
gem "rest-client", "~> 2"
gem "sanitize", "~> 4" # Sanitize user input
gem "warden", "1.2.4" # This dep of devise has a bug in 1.2.5 so am avaoiding
gem "whenever", "~> 0", require: false # Cron jobs
gem "will_paginate", "~> 3.0"
gem "xmlrpc"

# For creating many records, quickly
gem "fast_inserter", "~> 0.1"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api
  gem "sdoc", require: false
end

group :development do
  gem "better_errors", "~> 2"
  gem "binding_of_caller", "~> 0"
  gem "rails-dev-tweaks", "~> 1.1"
  gem "rb-fchange", "~> 0", require: false
  gem "rb-fsevent", "~> 0", require: false
  gem "rb-inotify", "~> 0", require: false
end

group :test do
  gem "webmock", "~> 2"
end

group :development, :test do
  gem "byebug"
  gem "capybara", "~> 3.26"
  gem "cucumber-rails", "1.6.0", require: false
  gem "database_cleaner", "~> 1"
  gem "factory_girl_rails", "~> 4"
  gem "poltergeist", "~> 1"
  gem "rails-controller-testing"
  gem "rspec-core", "~> 3"
  gem "rspec-rails", "~> 3"
  gem "rubocop", "0.52.0"
  gem "rubocop-github", "0.9.0"
  gem "selenium-webdriver", "~> 3"
  gem "webdrivers", "~> 4"
end

group :production do
  gem "puma", "~> 4"
end
