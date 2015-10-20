ruby '2.1.2'
source 'https://rubygems.org'

gem 'rails', '~>4.1.10'

#Database
gem 'pg', '0.15.1'
gem 'mysql2'

# Hosting-related
gem 'rails_12factor', group: :production # Loads 'rails_serve_static_assets' and 'rails_stdout_logging'
gem 'figaro'
gem 'aws-sdk'

# Frontend/assets
gem 'bourbon'
gem 'fontello_rails_converter'
gem 'webshims-rails'
gem 'redcarpet'               # Markdown
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'    # compressor for JavaScript assets
gem 'bundler', '>= 1.8.4' # needed for rails-assets
source 'https://rails-assets.org' do
  gem 'rails-assets-lodash'
  gem 'rails-assets-jquery'
  gem 'rails-assets-jquery-ujs'
  gem 'rails-assets-jquery-timeago'
  gem 'rails-assets-jquery-cookie'
  gem 'rails-assets-moment'
  gem 'rails-assets-backbone'
  gem 'rails-assets-backbone-relational'
  gem 'rails-assets-chartjs'
  gem 'rails-assets-respond'
  gem 'rails-assets-EpicEditor'
  gem 'rails-assets-bootstrap-daterangepicker'
  gem 'rails-assets-html5shiv'
  gem 'rails-assets-bootstrap-sass'
  gem 'rails-assets-ionicons'
  gem 'rails-assets-sweetalert'
  gem 'rails-assets-roboto-webfont'
  gem 'rails-assets-congress-images-102x125'
  gem 'rails-assets-jquery-sortable' # note: no bower.json for 0.9.12
end


# File upload
gem 's3_cors_fileupload', git: 'https://github.com/sinak/s3_cors_fileupload'
gem "paperclip", "~> 4.1"
gem "jquery-fileupload-rails"

# Email preformatting
gem 'nokogiri'                    # Required for premailer-rails
gem 'premailer-rails'             # Inline styles for emails

# Optimization
gem 'rack-zippy'                  # gzip assets
gem 'sprockets-image_compressor'  # Optimizes png/jpg


# Analytics
gem 'ahoy_matey'                  # Analytics
gem 'groupdate'
gem 'chartkick', git: 'https://github.com/Hainish/chartkick.git', branch: 'chart.js'

# Job queue
gem 'delayed_job_active_record'
gem 'daemons'

# Exception monitoring
gem 'sentry-raven'

# Other
gem 'acts_as_paranoid', git: 'https://github.com/ActsAsParanoid/acts_as_paranoid.git'
gem 'descriptive_statistics'      # Used for calculating percentiles
gem 'devise'
gem 'ejs'                         # Embedded javascript
gem 'friendly_id', '~> 5.0'       # Slugging/permalink plugins for Active Record
gem 'going_postal'                # Zip code validation
gem 'gravatar-ultimate'
gem 'has_heartbeat'               # Uptime monitoring
gem 'http_accept_language'        # Detect HTTP language header
gem 'jbuilder', '~> 1.2'          # JSON APIs 
gem 'whenever', require: false    # Cron jobs
gem 'sanitize'                    # Sanitize user input
gem 'rest_client'
gem 'sunlight-congress', git: 'https://github.com/steveklabnik/sunlight-congress'
gem 'will_paginate', '~> 3.0' 
gem 'oauth'
gem 'email_validator'
gem 'iso_country_codes'

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

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'pry'
  gem 'factory_girl_rails'
end

group :production do
  gem 'unicorn'
end

