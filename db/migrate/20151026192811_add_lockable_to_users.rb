class AddLockableToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :failed_attempts, :integer, default: 0
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime

    add_index :users, :unlock_token,         :unique => true
  end
end
