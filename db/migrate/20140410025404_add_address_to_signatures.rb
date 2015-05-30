class AddAddressToSignatures < ActiveRecord::Migration
  def change
    add_column :signatures, :street_address, :string
    add_column :signatures, :city, :string
    add_column :signatures, :state, :string
  end
end
