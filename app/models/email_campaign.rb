class EmailCampaign < ApplicationRecord
  belongs_to :topic_category
  has_one :action_page

  # No DC
  STATES = %w[AK AL AR AZ CA CO CT DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY].freeze

  def email_your_rep_text(default)
    target_bioguide_text_or_default alt_text_email_your_rep, default
  end

  def look_up_your_rep_text(default)
    target_bioguide_text_or_default alt_text_look_up_your_rep, default
  end

  def look_up_helper_text(default)
    target_bioguide_text_or_default alt_text_look_up_helper, default
  end

  def customize_message_helper_text(default)
    target_bioguide_text_or_default alt_text_customize_message_helper, default
  end

  def extra_fields_explain_text(default)
    target_bioguide_text_or_default alt_text_extra_fields_explain, default
  end

  def leg_level
    return "legislatorLowerBody" if target_state_lower_chamber
    return "legislatorUpperBody" if target_state_upper_chamber
    return "headOfGovernment" if target_governor

    ""
  end

  include ERB::Util

  def service_uri(service, opts = {})
    mailto_addresses = opts[:email]
    mailto_addresses ||= email_addresses
    # look for custom email addresses set on the back end if there is no email param from the front-end,
    # as is the case when we send state-level emails -- we cannot store these email address in our db,
    # reason below:

    # https://developers.google.com/terms#e_prohibitions_on_content
    # Section 5.e.1., as of December 2022
    # e. Prohibitions on Content
    # Unless expressly permitted by the content owner or by applicable law, you will not, and will not permit your end users or others acting on your behalf to, do the following with content returned from the APIs:
    # Scrape, build databases, or otherwise create permanent copies of such content, or keep cached copies longer than permitted by the cache header;

    # results in comma-separated string of email addresses
    default_mailto_addresses ||= mailto_addresses.split(/\s*,\s*/).map do |email|
      u(email.delete(" ")).gsub("%40", "@").gsub("%2B", "+")
    end.join(",")

    {
      default: "mailto:#{default_mailto_addresses}?#{query(body: message, subject: subject)}",

      gmail: "https://mail.google.com/mail/?view=cm&fs=1&#{{ to: mailto_addresses, body: message, su: subject }.to_query}",

      hotmail: "https://outlook.live.com/default.aspx?rru=compose&#{{ to: mailto_addresses, body: message, subject: subject }.to_query}#page=Compose"
    }.fetch(service.to_sym)
  end

  private

  # like Hash#to_query except we percent encode spaces
  def query(hash)
    hash.collect do |key, value|
      "#{u(key)}=#{u(value)}"
    end.compact * "&"
  end

  def target_bioguide_text_or_default(custom_text, default)
    if !target_bioguide_id || custom_text.blank?
      default
    else
      custom_text
    end
  end
end
