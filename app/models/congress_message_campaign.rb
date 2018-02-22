class CongressMessageCampaign < ActiveRecord::Base
  belongs_to :topic_category
  has_one :action_page

  scope :targets_bioguide_ids, ->{ where("target_bioguide_ids IS NOT NULL") }

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
end
