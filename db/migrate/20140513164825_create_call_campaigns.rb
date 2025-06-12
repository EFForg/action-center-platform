class CreateCallCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :call_campaigns do |t|

      t.timestamps
    end
  end
end
