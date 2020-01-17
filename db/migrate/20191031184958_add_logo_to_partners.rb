class AddLogoToPartners < ActiveRecord::Migration[5.0]
  def up
    add_attachment :partners, :logo
    add_column :partnerships, :enable_mailings, :boolean, default: false, null: false
  end

  def down
    remove_attachment :partners, :logo
    remove_column :partnerships, :enable_mailings, :boolean, default: false, null: false
  end
end
