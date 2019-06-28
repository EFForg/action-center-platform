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
      "$ADDRESS_ZIP5": location[:zipcode],
      "$STATE": location[:state]
    }
  end

  def congress_forms_prefills(campaign)
    {
      "$NAME_FIRST" => current_first_name,
      "$NAME_LAST" => current_last_name,
      "$EMAIL" => current_email,
      "$PHONE" => current_user.try(:phone),
      "$ADDRESS_STREET" => current_street_address,
      "$ADDRESS_CITY" => current_city,
      "$SUBJECT" => campaign.subject,
      # @TODO fuzzy match for "$TOPIC"?
      # "$TOPIC": campaign.topic.name
    }
  end

  def congress_forms_field(field, campaign, message_attributes)
    # Try to guess the input based on saved info abou the campaign + user.
    prefill = congress_forms_prefills(campaign)[field.value]

    if message_attributes[field.value]
      # If the user has already provided this info in step 1, render it in a hidden field.
      hidden_field_tag field.value, message_attributes[field.value]
    elsif field.value == "$PHONE"
      telephone_field_tag field.value, prefill, congress_forms_field_defaults(field)
        .merge({
          class: "form-control bfh-phone",
          "data-format": "ddd-ddd-dddd",
          pattern: "^((5\\d[123467890])|(5[123467890]\\d)|([2346789]\\d\\d))-\\d\\d\\d-\\d\\d\\d\\d$",
          title: "Must be a valid US phone number entered in 555-555-5555 format"
        })
    elsif field.value == "$EMAIL"
      email_field_tag field.value, prefill, congress_forms_field_defaults(field)
    elsif field.is_select?
      # @TODO aria-label
      select_tag field.value, options_for_select(field.options_hash)
    else
      text_field_tag field.value, prefill, congress_forms_field_defaults(field)
    end
  end

  def congress_forms_field_defaults(field)
    { class: "form-control",
      placeholder: field.label,
      "aria-label": field.label,
      maxlength: field.max_length,
      required: true }
  end
end
