module ToolsHelper
  def congress_forms_email_values(campaign)
    {
      "$NAME_FIRST"     => current_first_name,
      "$NAME_LAST"      => current_last_name,
      "$ADDRESS_STREET" => current_street_address,
      "$ADDRESS_CITY"   => current_city,
      "$EMAIL"          => current_email,
      "$PHONE"          => current_user.try(:phone),
      "$SUBJECT"        => campaign.subject
    }
  end

  def ask_for_newsletter_signup?
    current_user.nil? && !params[:nosignup].present?
  end
end
