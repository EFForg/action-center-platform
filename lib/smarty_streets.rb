require 'rest_client'
module SmartyStreets
  def self.get_city_state(zipcode)
    url = "https://api.smartystreets.com/zipcode/"
    res = post(url, base_params.merge(zipcode: zipcode))
    if res && res.first
      res.first['city_states'].try :first
    end
  end

  private
  def self.post(url, params)
    begin
      res = JSON.parse RestClient.get("#{url}?#{params.to_query}")
      return res
    rescue => e
      puts "#{ e } (#{ e.class })!"
    end
  end

  def self.base_params
    {
      'auth-id' => Rails.application.secrets.smarty_streets_id,
      'auth-token' => Rails.application.secrets.smarty_streets_token
    }
  end
end
