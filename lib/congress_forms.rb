require "rest_client"

module CongressForms
  def self.url(path = "/", params = {}, bioguide_id = nil)
    url = Rails.application.config.congress_forms_url + path
    url += bioguide_id unless bioguide_id.nil?
    url += "?" + {
      debug_key: Rails.application.secrets.congress_forms_debug_key,
    }.merge(params).to_query
  end

  def self.post(path = "/", params = {}, bioguide_id = nil)
    begin
      JSON.parse RestClient.get(url(path, params, bioguide_id))
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error e
      return {}
    end
  end
end
