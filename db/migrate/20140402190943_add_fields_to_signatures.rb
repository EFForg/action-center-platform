class AddFieldsToSignatures < ActiveRecord::Migration
  def change
    add_column :signatures, :first_name, :string
    add_column :signatures, :last_name, :string
    add_column :signatures, :email, :string
    add_column :signatures, :country_code, :string
    add_column :signatures, :zipcode, :string
  end
end
