class AddStateToEmailCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :email_campaigns, :state, :string
  end
end
