class AddPartnerIdToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :partner_id, :integer
  end
end
