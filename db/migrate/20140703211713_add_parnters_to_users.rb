class AddParntersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :partner_id, :integer
  end
end
