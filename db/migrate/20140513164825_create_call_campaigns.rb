class CreateCallCampaigns < ActiveRecord::Migration
  def change
    create_table :call_campaigns do |t|

      t.timestamps
    end
  end
end
