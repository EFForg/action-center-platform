class AddPartnerIdToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :partner_id, :integer
  end
end
