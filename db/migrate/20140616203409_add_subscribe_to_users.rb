class AddSubscribeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :subscribe, :boolean, default: true
  end
end
