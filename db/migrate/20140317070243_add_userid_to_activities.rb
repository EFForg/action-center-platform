class AddUseridToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :user_id, :integer
  end
end
