module CongressMessageHelper
  def congress_forms_prefills(campaign, field)
    if field.value == "$TOPIC" && campaign.topic_category.present?
      return campaign.topic_category.best_match(field.options_hash)
    end
    {
      "$NAME_FIRST" => current_first_name,
      "$NAME_LAST" => current_last_name,
      "$EMAIL" => current_email,
      "$PHONE" => number_to_phone(current_user.try(:phone)),
      "$ADDRESS_STREET" => current_street_address,
      "$ADDRESS_CITY" => current_city,
      "$SUBJECT" => campaign.subject,
    }[field.value]
  end

  def congress_forms_field(field, campaign, message_attributes, bioguide_id = nil)
    if bioguide_id
      name = "member_attributes[#{bioguide_id}][#{field.value}]"
    else
      name = "common_attributes[#{field.value}]"
    end

    # Try to guess the input based on saved info about the campaign + user.
    prefill = congress_forms_prefills(campaign, field)

    if message_attributes[field.value]
      # If the user has already provided this info in step 1, render it in a hidden field.
      hidden_field_tag name, message_attributes[field.value]
    elsif field.value == "$PHONE"
      telephone_field_tag name, prefill, congress_forms_field_defaults(field)
        .merge({
          class: "form-control bfh-phone",
          "data-format": "ddd-ddd-dddd",
          pattern: "^((5\\d[123467890])|(5[123467890]\\d)|([2346789]\\d\\d))-\\d\\d\\d-\\d\\d\\d\\d$",
          title: "Must be a valid US phone number entered in 555-555-5555 format"
        })
    elsif field.value == "$EMAIL"
      email_field_tag name, prefill, congress_forms_field_defaults(field)
    elsif field.value.include?("ADDRESS") && !field.is_select?
      address_part = field.value.split("_").last.downcase
      address_part = "zipcode" if address_part.include? "zip"
      address_label = "Your address - #{address_part}"
      text_field_tag name, prefill, congress_forms_field_defaults(field, placeholder: address_label, "aria-label": address_label)
    elsif field.is_select?
      select_tag name, options_for_select(field.options_hash, prefill),
        class: "form-control", "aria-label": field.label, include_blank: field.label, required: true
    else
      text_field_tag name, prefill, congress_forms_field_defaults(field)
    end
  end

  def congress_forms_field_defaults(field, **overrides)
    { class: "form-control",
      placeholder: field.label,
      "aria-label": field.label,
      maxlength: field.max_length,
      required: true }.merge(overrides)
  end
end
