class ActionCloner
  def self.run(*args)
    new(*args).run
  end

  def initialize(action_page)
    @attrs = action_page.attributes.symbolize_keys
    @page = action_page
  end

  def run
    clean_attributes
    @clone = ActionPage.new(attrs)
    clone_campaign
    clone
  end

  private

  attr_reader :attrs, :clone, :page

  def clean_attributes
    unpublish
    unarchive
    @attrs = remove_attrs(@attrs)
  end

  def unpublish
    attrs[:published] = false
  end

  def unarchive
    attrs[:archived] = false
  end

  def remove_attrs(hash)
    to_remove = %i(id created_at updated_at slug tweet_id email_campaign_id
                   call_campaign_id petition_id congress_message_campaign_id)
    to_remove.each { |a| hash.delete a }
    hash
  end

  def clone_campaign
    campaign_sym, model = determine_campaign
    return unless campaign_sym && model
    campaign = page.send(campaign_sym)
    campaign_attrs = remove_attrs(campaign.attributes.symbolize_keys)
    clone.send("#{campaign_sym}=", model.new(campaign_attrs))
  end

  def determine_campaign
    return [:tweet, Tweet] if page.enable_tweet?
    return [:email_campaign, EmailCampaign] if page.enable_email?
    return [:petition, Petition] if page.enable_petition?
    return [:congress_message_campaign, CongressMessageCampaign] if page.enable_congress_message?
    return [:call_campaign, CallCampaign] if page.enable_call?
  end
end
