class AddTopicCategoryIdToEmailCampaigns < ActiveRecord::Migration
  def change
    add_column :email_campaigns, :topic_category_id, :integer
  end
end
