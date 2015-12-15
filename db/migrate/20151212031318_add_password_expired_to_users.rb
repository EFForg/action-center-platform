class AddPasswordExpiredToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_expired, :boolean
  end
end
