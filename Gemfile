source "https://rubygems.org"

gem "rails", "~> 6.0.0"

# Database
gem "pg", "~> 1.1"
gem "pg_search", "~> 2"

# Hosting-related
gem "aws-sdk-rails", "~> 2"
gem "aws-sdk-s3", "~> 1"
gem "dotenv-rails", "~> 2"
gem "rack-attack", "~> 5"
gem "rails_response_headers", "~> 0.2"

# Frontend/assets
gem "bootstrap-daterangepicker-rails", "~> 3"
gem "bootstrap-sass", "~> 3.4"
gem "bourbon", "~> 3"
gem "bundler", ">= 1.8.4" # needed for rails-assets
gem "react-rails", "~> 1"
gem "redcarpet", "~> 3" # Markdown
gem "sass-rails", "< 5.1"
gem "select2-rails"               # Autocomplete select menus
gem "uglifier", ">= 1.3.0"        # compressor for JavaScript assets

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
gem "kt-paperclip", "~> 6"

# Email preformatting
gem "nokogiri", "~> 1"                    # Required for premailer-rails
gem "premailer-rails", "~> 1"             # Inline styles for emails

# Analytics
gem "ahoy_matey", "~> 1.6"
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
gem "activerecord-session_store", "~> 2"
gem "acts_as_paranoid", "~> 0.7"
gem "cocoon", "~> 1"                      # Dynamically add and remove nested associations from forms
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
gem "jbuilder", "~> 2"
gem "oauth", "~> 0"
gem "rest-client", "~> 2"
gem "sanitize", "~> 6" # Sanitize user input
gem "whenever", "~> 0", require: false # Cron jobs
gem "will_paginate", "~> 3.0"
gem "xmlrpc", "~> 0.3"

# For creating many records, quickly
gem "fast_inserter", "~> 0.1"

# Pin psych to below version 4 until we're on rails 7 and ruby 3.1
gem "psych", "< 4"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api
  gem "sdoc", require: false
end

group :development do
  gem "better_errors", "~> 2"
end

group :test do
  gem "webmock", "~> 3"
  gem "selenium-devtools"
end

group :development, :test do
  gem "byebug"
  gem "capybara", "~> 3"
  gem "database_cleaner", "~> 1"
  gem "factory_bot_rails", "~> 6.2"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 4.0"
  gem "rubocop"
  gem "rubocop-github", "~> 0.16"
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
end

group :production do
  gem "puma", "~> 3"
end
