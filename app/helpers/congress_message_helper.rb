module CongressMessageHelper
  def bioguide_ids(campaign, target_bioguide_ids)
    if campaign.target_bioguide_ids.present?
      campaign.target_bioguide_ids 
    elsif target_bioguide_ids.present?
      target_bioguide_ids.join(", ")
    else
      ""
    end
  end
end
