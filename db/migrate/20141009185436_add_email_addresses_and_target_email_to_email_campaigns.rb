class AddEmailAddressesAndTargetEmailToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :email_addresses, :string
    add_column :email_campaigns, :target_email, :boolean
  end
end
