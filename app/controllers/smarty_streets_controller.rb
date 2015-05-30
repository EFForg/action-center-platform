require 'rest_client'
class SmartyStreetsController < ApplicationController
  def street_address
    url = "https://api.smartystreets.com/street-address/?#{smarty_params.to_query}"
    render json: proxy_request(url), status: 200
  end

  def suggest
    url = "https://autocomplete-api.smartystreets.com/suggest?#{smarty_params.to_query}"
    render json: proxy_request(url), status: 200
  end

  private
  def proxy_request(url)
    begin
      return RestClient.get url, accept: :json, :'X-Include-Invalid' => 'true'
    rescue => e
      puts e
    end
  end

  def smarty_params
    params.merge(
      'auth-id' => Rails.application.secrets.smarty_streets_id,
      'auth-token' => Rails.application.secrets.smarty_streets_token
    )
  end
end
