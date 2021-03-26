class AddTopicCategoryIdToEmailCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :email_campaigns, :topic_category_id, :integer
  end
end
