require "rest_client"

# From Google, the API provider (September 2022):
# Reference link: https://developers.google.com/civic-information/docs/data_guidelines?hl=en
# "Developer’s using the API should make every effort to ensure all users are met with the same experience. We
# do not allow holdbacks, A/B testing, or similar experiments."

module CivicApi
  # supported `roles` are: "legislatorLowerBody", "legislatorUpperBody", or "headOfGovernment"
  def self.state_rep_search(address, roles)
    unless [address, roles].all?
      raise ArgumentError.new("required argument is nil")
    end

    # `includeOffices` param is needed in order to get officials list
    # `administrativeArea1` param restricts the search to state-level legislators (and governors)
    params = { address: address, includeOffices: true, levels: "administrativeArea1", roles: roles, key: civic_api_key }

    get params
  end

  # supported `roles` are: "legislatorLowerBody", "legislatorUpperBody", or "headOfGovernment"
  def self.all_state_reps_by_role(state, roles)
    unless [state, roles].all?
      raise ArgumentError.new("required argument is nil")
    end

    # need to append division information to API route
    path_params = { ocdId: "ocd-division%2Fcountry%3Aus%2Fstate%3A#{state.downcase}" }
    # `administrativeArea1` param restricts the search to state-level legislators (and governors)
    query_params = { levels: "administrativeArea1", recursive: true, roles: roles, key: civic_api_key }

    params = { path_params: path_params, query_params: query_params }

    get params
  end

  private

  def self.civic_api_key
    Rails.application.secrets.google_civic_api_key
  end

  def self.endpoint
    Rails.application.config.google_civic_api_url
  end

  def self.get(params = {})
    if params[:path_params].nil?
      url = endpoint
    else
      ocd_encpoint = endpoint.clone
      url = ocd_encpoint.concat(params[:path_params][:ocdId])
      params = params[:query_params]
    end
    RestClient.get url, params: params
  rescue RestClient::BadRequest => e
    error = JSON.parse(e.http_body)["error"]
    raise error
  end
end
