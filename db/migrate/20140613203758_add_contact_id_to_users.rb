class AddContactIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contact_id, :integer
  end
end
