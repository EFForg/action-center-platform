class AddCampaignTagToEmailCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :email_campaigns, :campaign_tag, :string
  end
end
