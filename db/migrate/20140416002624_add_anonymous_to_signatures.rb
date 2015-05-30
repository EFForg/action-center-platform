class AddAnonymousToSignatures < ActiveRecord::Migration
  def change
    add_column :signatures, :anonymous, :boolean, default: false
  end
end
