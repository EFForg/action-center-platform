module ActionCloner
  def self.run(original)
    clone = original.dup
    clone.published = false
    clone.archived = false
    clone_campaign(original, clone)
  end

  private

  def self.clone_campaign(page, clone)
    campaign_sym, model = determine_campaign(page)
    return clone unless campaign_sym && model
    campaign = page.send(campaign_sym)
    clone.send("#{campaign_sym}=", campaign.dup)
    clone
  end

  def self.determine_campaign(page)
    return [:tweet, Tweet] if page.enable_tweet?
    return [:email_campaign, EmailCampaign] if page.enable_email?
    return [:petition, Petition] if page.enable_petition?
    return [:congress_message_campaign, CongressMessageCampaign] if page.enable_congress_message?
    return [:call_campaign, CallCampaign] if page.enable_call?
  end
end
