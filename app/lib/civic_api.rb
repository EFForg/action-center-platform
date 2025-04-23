require "rest_client"

# From Google, the API provider (September 2022):
# Reference link: https://developers.google.com/civic-information/docs/data_guidelines?hl=en
# "Developer’s using the API should make every effort to ensure all users are met with the same experience. We
# do not allow holdbacks, A/B testing, or similar experiments."

module CivicApi
  VALID_ROLES = %w[legislatorLowerBody legislatorUpperBody
                   headOfGovernment].freeze

  #  4/22 note - address and roles are both strings for now, as we
  #  don't yet support multiple targets for state campaigns
  def self.state_rep_search(address, roles)
    unless [address, roles].all?(&:present?)
      missing_fields = []
      missing_fields << :address unless address.present?
      missing_fields << :roles unless roles.present?
      raise ArgumentError, "required argument(s) `#{missing_fields.join(", ")}` is nil"
    end
    unless VALID_ROLES.include?(roles)
      raise ArgumentError, "Invalid role for Civic API `#{roles}`"
    end

    # `includeOffices` param is needed in order to get officials list
    # `administrativeArea1` param restricts the search to state-level
    #   legislators (and governors)
    params = {
      address: address,
      includeOffices: true,
      levels: "administrativeArea1",
      roles: roles,
      key: civic_api_key
    }

    response = get params
    JSON.parse(response.body)["officials"]
  end

  def self.all_state_reps_for_role(state, roles)
    raise ArgumentError, "required argument is nil" unless [state, roles].all?

    # need to append division information to API route
    path_params = {
      ocdId: "ocd-division%2Fcountry%3Aus%2Fstate%3A#{state.downcase}"
    }
    # `administrativeArea1` param restricts the search to state-level
    #   legislators (and governors)
    query_params = {
      levels: "administrativeArea1",
      recursive: true,
      roles: roles,
      key: civic_api_key
    }

    params = { path_params: path_params, query_params: query_params }

    get params
  end

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
