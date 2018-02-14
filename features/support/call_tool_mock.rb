require "call_tool"

def senate_call_campaign_id; 1; end

def custom_call_campaign_id; 2; end

module CallTool
  def self.required_fields_for_campaign(campaign_id)
    case campaign_id.to_i
    when senate_call_campaign_id
      { "userLocation" => "district" }

    when custom_call_campaign_id
      {}
    end
  end

  def self.campaign_call(*args)
    warn "mock: campaign_call"
  end

  def self.enabled?
    true
  end

  def self.campaigns
    [{ "id" => 1, "name" => "Call Someone", "status" => "live" }]
  end
end
