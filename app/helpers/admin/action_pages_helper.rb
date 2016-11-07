module Admin
  module ActionPagesHelper
    def call_campaign_options_for_select
      if CallTool.enabled?
        CallTool.campaigns.map do |campaign|
          ["#{campaign['name']} (#{campaign['status']})", campaign["id"]]
        end.sort_by(&:last).reverse
      else
        []
      end

    rescue SystemCallError, RestClient::Exception
      []
    end
  end
end
