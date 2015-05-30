class AddTargetBioguideIdToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :target_bioguide_id, :boolean, default: false
    add_column :email_campaigns, :bioguide_id, :string
  end
end
