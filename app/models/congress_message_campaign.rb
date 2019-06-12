require "rest_client"
class CongressMessageCampaign < ActiveRecord::Base
  belongs_to :topic_category
  has_one :action_page

  scope :targets_bioguide_ids, -> { where("target_bioguide_ids IS NOT NULL") }

  before_validation :normalize_fields

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

  def target_specific_legislators
    !(target_house || target_senate)
  end

  def date_fills(start_date = nil, end_date = nil)
    begin
      r = RestClient.get(date_fills_url(start_date, end_date))
      JSON.parse r
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error e
      return {}
    end
  end

  def date_fills_url(start_date = nil, end_date = nil, bioguide_id = nil)
    params = {
      date_start: start_date,
      date_end: end_date,
      campaign_tag: campaign_tag
    }.compact
    CongressMessageCampaign.url("/successful-fills-by-date/", params, bioguide_id)
  end

  private

  def target_bioguide_text_or_default(custom_text, default)
    if !target_bioguide_ids or custom_text.blank?
      default
    else
      custom_text
    end
  end

  def normalize_fields
    self.target_bioguide_ids = nil if target_bioguide_ids.blank?
    self.alt_text_email_your_rep = nil if alt_text_email_your_rep.blank?
    self.alt_text_look_up_your_rep = nil if alt_text_look_up_your_rep.blank?
    self.alt_text_extra_fields_explain = nil if alt_text_extra_fields_explain.blank?
    self.alt_text_look_up_helper = nil if alt_text_look_up_helper.blank?
    self.alt_text_customize_message_helper = nil if alt_text_customize_message_helper.blank?
  end

  def self.url(path = "/", params = {}, bioguide_id = nil)
    url = Rails.application.config.congress_forms_url + path
    url += bioguide_id unless bioguide_id.nil?
    url += "?" + {
      debug_key: Rails.application.secrets.congress_forms_debug_key,
    }.merge(params).to_query
  end
end
