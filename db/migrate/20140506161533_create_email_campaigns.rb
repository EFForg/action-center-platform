class CreateEmailCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :email_campaigns do |t|
      t.text :message

      t.timestamps
    end
  end
end
