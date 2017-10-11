require 'rest_client'
module SmartyStreets
  def self.get_city_state(zipcode)
    url = "https://us-zipcode.api.smartystreets.com/lookup"
    res = post(url, base_params.merge(zipcode: zipcode))
    if res && !res.empty?
      res.first['city_states'].try :first
    end
  end

  def self.get_congressional_district(street, zipcode)
    url = "https://api.smartystreets.com/street-address"
    res = post(url, base_params.merge(street: street, zipcode: zipcode))
    if res && res.first
      district = res.first.dig("metadata", "congressional_district")
      district = "0" if district == "AL"
      [res.first["components"]["state_abbreviation"], district]
    end
  end

  private
  def self.post(url, params)
    begin
      res = JSON.parse RestClient.get("#{url}?#{params.to_query}")
      return res
    rescue => e
      Rails.logger.error "#{ e } (#{ e.class })!"
      return false
    end
  end

  def self.base_params
    {
      'auth-id' => Rails.application.secrets.smarty_streets_id,
      'auth-token' => Rails.application.secrets.smarty_streets_token
    }
  end
end
