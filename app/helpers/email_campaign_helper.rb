module EmailCampaignHelper
  def legislative_level_from_state_representative_info(legislator_info)
    role = case legislator_info
    when "legislatorLowerBody"
      "state representative of the lower chamber"
    when "legislatorUpperBody"
      "state representative of the upper chamber"
    when "headOfGovernment"
      "Governor of the State"
    else
      "Invalid info"
    end
    role
  end
end
