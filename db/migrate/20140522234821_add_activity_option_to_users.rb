class AddActivityOptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :record_activity, :boolean, default: true
  end
end
