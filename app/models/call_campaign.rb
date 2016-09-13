
require "call_tool"

class CallCampaign < ActiveRecord::Base
  has_one :action_page

  def required_fields
    CallTool.required_fields_for_campaign(self)
  end

  def connect(**kwargs)
    CallTool.campaign_call(self, **kwargs)
  end
end
