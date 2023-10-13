class AddContactIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :contact_id, :integer
  end
end
