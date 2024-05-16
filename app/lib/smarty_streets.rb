require "rest_client"
module SmartyStreets
  def self.get_city_state(zipcode)
    url = "https://us-zipcode.api.smartystreets.com/lookup"
    res = post(url, base_params.merge(zipcode: zipcode))
    res.first["city_states"].try :first if res.present?
  end

  def self.get_location(street, zipcode)
    url = "https://api.smartystreets.com/street-address"
    res = post(url, base_params.merge(street: street, zipcode: zipcode))
    raise AddressNotFound if res.blank?

    location = OpenStruct.new
    location.street = street
    location.zipcode = zipcode
    location.city = res[0]["components"]["city_name"]
    location.zip4 = res[0]["components"]["plus4_code"]
    location.state = res[0]["components"]["state_abbreviation"]
    location.district = res[0]["metadata"]["congressional_district"]
    location.district = "0" if location.district == "AL"
    location
  end

  def self.get_congressional_district(street, zipcode)
    location = get_location(street, zipcode)
    [location.state, location.district]
  end

  class AddressNotFound < StandardError; end

  def self.post(url, params)
    JSON.parse RestClient.get("#{url}?#{params.to_query}")
  rescue StandardError => e
    Raven.capture_exception(e)
    Rails.logger.error "#{e} (#{e.class})!"
    false
  end

  def self.base_params
    {
      "auth-id" => Rails.application.secrets.smarty_streets_id,
      "auth-token" => Rails.application.secrets.smarty_streets_token
    }
  end
end
