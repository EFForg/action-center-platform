class AddSubjectToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :subject, :string
  end
end
