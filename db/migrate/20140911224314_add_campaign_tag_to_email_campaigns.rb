class AddCampaignTagToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :campaign_tag, :string
  end
end
