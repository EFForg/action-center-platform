class CongressMessageCampaign < ActiveRecord::Base
  belongs_to :topic_category
  has_one :action_page

  before_validation ->{ self.target_bioguide_ids = nil if target_bioguide_ids.blank? }

  def email_your_rep_text default
    default
  end

  def look_up_your_rep_text default
    default
  end

  def look_up_helper_text default
    default
  end

  def customize_message_helper_text default
    default
  end

  def extra_fields_explain_text default
    default
  end

  def target_specific_legislators
    not (target_house || target_senate)
  end
end
