class AddStateTargetsToEmailCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :email_campaigns, :target_state_lower_chamber, :boolean
    add_column :email_campaigns, :target_state_upper_chamber, :boolean
    add_column :email_campaigns, :target_governor, :boolean
  end
end
