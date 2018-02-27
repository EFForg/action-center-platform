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

  def congress_forms_email_values(campaign, location)
    location ||= {}
    {
      "$NAME_FIRST": current_first_name,
      "$NAME_LAST": current_last_name,
      "$EMAIL": current_email,
      "$PHONE": current_user.try(:phone),
      "$SUBJECT": campaign.subject,
      "$ADDRESS_STREET": location[:street] || current_street_address,
      "$ADDRESS_CITY": location[:city] || current_city,
      "$ADDRESS_ZIP4": location[:zip4],
      "$ADDRESS_ZIP5": location[:zip5],
      "$STATE": location[:state]
    }
  end
end
