class EmailCampaign < ActiveRecord::Base
  belongs_to :topic_category
  has_one :action_page

  def email_your_rep_text default
    target_bioguide_text_or_default alt_text_email_your_rep, default
  end

  def look_up_your_rep_text default
    target_bioguide_text_or_default alt_text_look_up_your_rep, default
  end

  def look_up_helper_text default
    target_bioguide_text_or_default alt_text_look_up_helper, default
  end

  def customize_message_helper_text default
    target_bioguide_text_or_default alt_text_customize_message_helper, default
  end

  def extra_fields_explain_text default
    target_bioguide_text_or_default alt_text_extra_fields_explain, default
  end

  include ERB::Util

  def service_uri(service)
    mailto_addresses = email_addresses.split(/\s*,\s*/).map do |email|
      u(email.gsub(" ", "")).gsub("%40", "@")
    end.join(",")

    message_brs = message.gsub("\r\n", "<br>")

    {
      default: "mailto:#{mailto_addresses}?#{query(body: message, subject: subject)}",

      gmail: "https://mail.google.com/mail/?view=cm&fs=1&#{query(to: email_addresses, body: message, su: subject)}",

      # couldn't get newlines to work here, see: https://stackoverflow.com/questions/1632335/uri-encoding-in-yahoo-mail-compose-link
      yahoo: "http://compose.mail.yahoo.com/?#{query(to: email_addresses, subj: subject, body: message)}",

      hotmail: "https://outlook.live.com/default.aspx?rru=compose&#{query(to: email_addresses, body: message_brs, subject: subject)}#page=Compose"
    }.with_indifferent_access.fetch(service)
  end

  private

  # like Hash#to_query except we percent encode spaces
  def query(hash)
    hash.collect do |key, value|
      "#{u(key)}=#{u(value)}"
    end.compact.sort! * '&'
  end

  def target_bioguide_text_or_default custom_text, default
    if not target_bioguide_id or custom_text.blank?
      default
    else
      custom_text
    end
  end

end
