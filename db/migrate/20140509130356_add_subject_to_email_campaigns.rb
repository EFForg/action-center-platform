class AddSubjectToEmailCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :email_campaigns, :subject, :string
  end
end
