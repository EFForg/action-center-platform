class ChangeSubscriptionDefaults < ActiveRecord::Migration
  def up
    change_column :users, :subscribe, :boolean, default: false
    change_column :users, :record_activity, :boolean, default: false
  end

  def down
    change_column :users, :subscribe, :boolean, default: true
    change_column :users, :record_activity, :boolean, default: true
  end
end
