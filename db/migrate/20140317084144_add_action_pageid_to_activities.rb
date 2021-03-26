class AddActionPageidToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :action_page_id, :integer
  end
end
