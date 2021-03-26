class AddParntersToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :partner_id, :integer
  end
end
