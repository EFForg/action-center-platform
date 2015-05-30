class AddTypeToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :action_type, :string
  end
end
