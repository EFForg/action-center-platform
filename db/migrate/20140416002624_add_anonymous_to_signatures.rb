class AddAnonymousToSignatures < ActiveRecord::Migration[5.0]
  def change
    add_column :signatures, :anonymous, :boolean, default: false
  end
end
