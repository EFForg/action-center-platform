ruby '2.3.1'
source 'https://rubygems.org'

gem 'rails', '~>4.2.6'

#Database
gem 'pg', '0.15.1'

# Hosting-related
gem 'rails_12factor', group: :production # Loads 'rails_serve_static_assets' and 'rails_stdout_logging'
gem 'aws-sdk', '< 2.0'
gem 'dotenv-rails'

# Frontend/assets
gem 'bourbon'
gem 'fontello_rails_converter'
gem 'webshims-rails'
gem 'redcarpet'                   # Markdown
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'        # compressor for JavaScript assets
gem 'bundler', '>= 1.8.4'         # needed for rails-assets
gem 'select2-rails'               # Autocomplete select menus
source 'https://rails-assets.org' do
  gem 'rails-assets-lodash', '3.7.0'
  gem 'rails-assets-jquery', '2.1.3'
  gem 'rails-assets-jquery-ujs', '1.0.3'
  gem 'rails-assets-jquery-timeago'
  gem 'rails-assets-jquery-cookie'
  gem 'rails-assets-moment', '2.9.0'
  gem 'rails-assets-backbone', '1.1.2'
  gem 'rails-assets-backbone-relational', '0.9.0'
  gem 'rails-assets-chartjs'
  gem 'rails-assets-respond'
  gem 'rails-assets-EpicEditor'
  gem 'rails-assets-bootstrap-daterangepicker', '1.3.21'
  gem 'rails-assets-html5shiv', '3.7.2'
  gem 'rails-assets-bootstrap-sass', '3.3.4'
  gem 'rails-assets-ionicons'
  gem 'rails-assets-sweetalert', '1.0.1'
  gem 'rails-assets-roboto-webfont'
  gem 'rails-assets-congress-images-102x125'
  gem 'rails-assets-jquery-sortable', '0.9.12' # note: no bower.json for 0.9.12
end


# File upload
gem 's3_cors_fileupload', git: 'https://github.com/sinak/s3_cors_fileupload', ref: 'd5e14'
gem "paperclip", "~> 4.1"
gem "jquery-fileupload-rails"

# Email preformatting
gem 'nokogiri'                    # Required for premailer-rails
gem 'premailer-rails'             # Inline styles for emails

# Optimization
gem 'sprockets-image_compressor'  # Optimizes png/jpg


# Analytics
gem 'ahoy_matey'                  # Analytics
gem 'groupdate'
gem 'chartkick'

# Job queue
gem 'delayed_job_active_record'
gem 'daemons'

# Exception monitoring
gem 'sentry-raven', '~> 0.15'

# Other
gem 'acts_as_paranoid', git: 'https://github.com/ActsAsParanoid/acts_as_paranoid.git', :ref => 'ddcd1'
gem 'descriptive_statistics'      # Used for calculating percentiles
gem 'warden', '1.2.4'             # This dep of devise has a bug in 1.2.5 so am avaoiding
gem 'devise', '~> 3.5'
gem 'ejs'                         # Embedded javascript
gem 'friendly_id', '~> 5.0'       # Slugging/permalink plugins for Active Record
gem 'going_postal'                # Zip code validation
gem 'gravatar-ultimate'
gem 'http_accept_language'        # Detect HTTP language header
gem 'jbuilder', '~> 1.2'          # JSON APIs
gem 'whenever', require: false    # Cron jobs
gem 'sanitize'                    # Sanitize user input
gem 'rest-client'
gem 'will_paginate', '~> 3.0'
gem 'oauth'
gem 'email_validator'
gem 'iso_country_codes'
gem 'cocoon'                      # Dynamically add and remove nested associations from forms

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api
  gem 'sdoc', require: false
end

group :development do
  gem 'rb-inotify', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-fchange', require: false
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rails-dev-tweaks', '~> 1.1'
end

group :test do
  gem "webmock"
end

group :development, :test do
  gem 'rspec-core'
  gem 'rspec-rails'
  gem 'cucumber-rails', '1.4.2', require: false
  gem 'capybara', '~> 2.5.0'
  gem 'selenium-webdriver', '~> 2.49', require: false
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'pry'
  gem 'factory_girl_rails'
  gem "codeclimate-test-reporter", require: nil
end

group :production do
  gem 'unicorn'
end
