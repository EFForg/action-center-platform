# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, :email, :first_name, :last_name, :zipcode, :street_address, :city, :state, :country_code, :phone]
