class AddPasswordExpiredToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :password_expired, :boolean
  end
end
