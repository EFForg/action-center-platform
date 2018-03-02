require "rest_client"

class SmartyStreetsController < ApplicationController
  # POST /smarty_streets/street_address
  #
  # Pass in street and zipcode params and this function
  # checks if an address+zip exists, exposes zip+4
  def street_address
    render json: get_data_on_address_zip(params), status: 200
  end

  # This endpoint appears unused
  def suggest
    render json: get_suggestions_for_address(params), status: 200
  end

  private

  def get_data_on_address_zip(params)
    query = authorize_query(params)

    url = "https://api.smartystreets.com/street-address/?#{query}"
    proxy_request(url).as_json
  end

  def get_suggestions_for_address(params)
    query = authorize_query(params)

    url = "https://autocomplete-api.smartystreets.com/suggest?#{query}"
    proxy_request(url).as_json
  end

  def authorize_query(params)
    params.merge(
      "auth-id" => Rails.application.secrets.smarty_streets_id,
      "auth-token" => Rails.application.secrets.smarty_streets_token
    ).to_query
  end

  def proxy_request(url)
    begin
      return RestClient.get url, accept: :json, 'X-Include-Invalid': "true"
    rescue => e
      logger.error e
    end
  end
end
