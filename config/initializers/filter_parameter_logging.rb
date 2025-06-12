# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
    :password,
    :email,
    :first_name,
    /name_first/i,
    /name_last/i,
    :last_name,
    :street_address,
    # :zipcode,
    :street,
    :city,
    :state,
    :country_code,
    :phone,
    :passw,
    :secret,
    :token,
    :_key,
    :crypt,
    :salt,
    :certificate,
    :otp,
    :ssn,
    /^\$?message$/i, # for congress message body
]
