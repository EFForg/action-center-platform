require "rest_client"

module CallTool
  def self.campaign_call(campaign, phone:, location:, user_id:, action_id:, callback_url:)
    unless [campaign, phone, location, action_id, callback_url].all?
      raise ArgumentError.new("required argument is nil")
    end

    get "/call/create", {
      campaignId: campaign.to_param,
      userPhone:  phone,
      userCountry: "US",
      userLocation: location,
      callback_url: callback_url,

      # TODO - Settle on the schema of the private meta data
      meta: {
        user_id:     user_id,
        action_id:   action_id,
        action_type: "call"
      }.to_json,
    }
  end

  def self.required_fields_for_campaign(campaign)
    response = get "/api/campaign/#{campaign.to_param}", { api_key: api_key }
    JSON.parse(response.body)["required_fields"]
  end

  def self.campaigns
    campaigns = []

    api_response = { "total_pages" => 1, "page" => 0 }
    until api_response["page"] >= api_response["total_pages"]
      api_response = JSON.parse(get "/api/campaign", { api_key: api_key, page: api_response["page"] + 1 })

      campaigns.concat(api_response["objects"].map { |campaign| campaign.slice("id", "name", "allow_call_in", "phone_numbers", "status") })
    end

    campaigns
  end

  def self.enabled?
    Rails.application.secrets.fetch_values(:call_tool_url, :call_tool_api_key).all?
  end

  private

  def self.get(action, params = {})
    RestClient.get endpoint(action), params: params
  rescue RestClient::BadRequest => e
    begin
      error = JSON.parse(e.http_body)["error"]
    rescue
      raise
    end

    # Don't raise for twilio error 13224: number invalid
    unless error.match(/^13224:/)
      if Rails.application.secrets.sentry_dsn.nil?
        raise error
      else
        Raven.capture_message(error, level: "info")
      end
    end
  end

  def self.endpoint(action)
    base = Rails.application.config.call_tool_url.sub(/\/$/, "")
    action = action.sub(/^\//, "")
    "#{base}/#{action}"
  end

  def self.api_key
    Rails.application.secrets.call_tool_api_key
  end
end
