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

  private

  def target_bioguide_text_or_default custom_text, default
    if not target_bioguide_id or custom_text.blank?
      default
    else
      custom_text
    end
  end

end
