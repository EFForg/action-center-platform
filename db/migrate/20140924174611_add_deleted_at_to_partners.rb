class AddDeletedAtToPartners < ActiveRecord::Migration[5.0]
  def change
    add_column :partners, :deleted_at, :time
  end
end
