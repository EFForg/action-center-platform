source "https://rubygems.org"

gem "rails", "~>4.2.6"

#Database
gem "pg", "0.15.1"

# Hosting-related
gem "aws-sdk", "< 2.0"
gem "dotenv-rails"
gem "rack-attack"
gem "rails_12factor", group: :production # Loads "rails_serve_static_assets" and "rails_stdout_logging"

# Frontend/assets
gem "bourbon"
gem "bundler", ">= 1.8.4"         # needed for rails-assets
gem "fontello_rails_converter"
gem "react-rails"
gem "redcarpet"                   # Markdown
gem "sass-rails", "~> 4.0.0"
gem "select2-rails"               # Autocomplete select menus
gem "uglifier", ">= 1.3.0"        # compressor for JavaScript assets
gem "webshims-rails"
source "https://rails-assets.org" do
  gem "rails-assets-bootstrap-daterangepicker", "1.3.21"
  gem "rails-assets-bootstrap-sass", "3.3.4"
  gem "rails-assets-chartjs"
  gem "rails-assets-congress-images-102x125"
  gem "rails-assets-EpicEditor"
  gem "rails-assets-html5shiv", "3.7.2"
  gem "rails-assets-ionicons"
  gem "rails-assets-jquery", "2.1.3"
  gem "rails-assets-jquery-cookie"
  gem "rails-assets-jquery-sortable", "0.9.12" # note: no bower.json for 0.9.12
  gem "rails-assets-jquery-timeago"
  gem "rails-assets-jquery-ujs", "1.0.3"
  gem "rails-assets-lodash", "3.7.0"
  gem "rails-assets-moment", "2.9.0"
  gem "rails-assets-respond"
  gem "rails-assets-roboto-webfont"
  gem "rails-assets-sweetalert", "1.0.1"
end

# File upload
gem "jquery-fileupload-rails"
gem "paperclip", "~> 4.1"
gem "s3_cors_fileupload", git: "https://github.com/sinak/s3_cors_fileupload", ref: "d5e14"

# Email preformatting
gem "nokogiri"                    # Required for premailer-rails
gem "premailer-rails"             # Inline styles for emails

# Optimization
gem "sprockets-image_compressor" # Optimizes png/jpg

# Analytics
gem "ahoy_matey" # Analytics
gem "chartkick"
gem "groupdate"

# Job queue
gem "daemons"
gem "delayed_job_active_record"

# Exception monitoring
gem "sentry-raven", "~> 0.15"

# Other
gem "activerecord-session_store"
gem "acts_as_paranoid", git: "https://github.com/ActsAsParanoid/acts_as_paranoid.git", ref: "ddcd1"
gem "cocoon"                      # Dynamically add and remove nested associations from forms
gem "descriptive_statistics"      # Used for calculating percentiles
gem "devise", "~> 3.5"
gem "ejs"                         # Embedded javascript
gem "email_validator"
gem "friendly_id", "~> 5.0"       # Slugging/permalink plugins for Active Record
gem "going_postal"                # Zip code validation
gem "gravatar-ultimate"
gem "http_accept_language"        # Detect HTTP language header
gem "invisible_captcha"           # Prevent form submissions by bots
gem "iso_country_codes"
gem "jbuilder", "~> 1.2"          # JSON APIs
gem "oauth"
gem "rest-client"
gem "sanitize"                    # Sanitize user input
gem "warden", "1.2.4"             # This dep of devise has a bug in 1.2.5 so am avaoiding
gem "whenever", require: false    # Cron jobs
gem "will_paginate", "~> 3.0"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api
  gem "sdoc", require: false
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "rails-dev-tweaks", "~> 1.1"
  gem "rb-fchange", require: false
  gem "rb-fsevent", require: false
  gem "rb-inotify", require: false
end

group :test do
  gem "puffing-billy", "~> 0.12.0"
  gem "webmock"
end

group :development, :test do
  gem "capybara", "~> 2.5.0"
  gem "cucumber-rails", "1.4.2", require: false
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "poltergeist"
  gem "pry"
  gem "rspec-core"
  gem "rspec-rails"
  gem "rubocop", "0.50.0"
  gem "rubocop-github", "0.5.0"
  gem "selenium-webdriver", "~> 2.49", require: false
end

group :production do
  gem "lograge"
  gem "puma"
end
