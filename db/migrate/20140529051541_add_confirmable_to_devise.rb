class AddConfirmableToDevise < ActiveRecord::Migration[5.0]
  # Note: You can't use change, as User.update_all with fail in the down migration
  def self.up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    # add_column :users, :unconfirmed_email, :string # Only if using reconfirmable
    add_index :users, :confirmation_token, :unique => true
    # User.reset_column_information # Need for some types of updates, but not for update_all.
    # To avoid a short time window between running the migration and updating all existing
    # users as confirmed, do the following
    User.update_all(:confirmed_at => Time.now)
    # All existing user accounts should be able to log in after this.
  end

  def self.down
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at
    # remove_columns :users, :unconfirmed_email # Only if using reconfirmable
  end
end
