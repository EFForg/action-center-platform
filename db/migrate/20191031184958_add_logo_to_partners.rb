class AddLogoToPartners < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :logo_file_name, :string
    add_column :action_pages, :logo_content_type, :string
    add_column :action_pages, :logo_file_size, :bigint
    add_column :action_pages, :logo_updated_at, :datetime
    add_column :partnerships, :enable_mailings, :boolean, default: false, null: false
  end
end
