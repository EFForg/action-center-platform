class AddActionPageidToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :action_page_id, :integer
  end
end
