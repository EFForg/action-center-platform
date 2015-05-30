class AddDeletedAtToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :deleted_at, :time
  end
end
