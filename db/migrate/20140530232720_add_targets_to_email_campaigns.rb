class AddTargetsToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :target_house, :boolean, default: true
    add_column :email_campaigns, :target_senate, :boolean, default: true
  end
end
