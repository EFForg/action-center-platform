class AddActivityOptionToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :record_activity, :boolean, default: true
  end
end
