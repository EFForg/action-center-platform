class CreateActionPartnerships < ActiveRecord::Migration
  def up
    create_table :action_partnerships do |t|
      t.belongs_to :action_page, index: true
      t.belongs_to :partner, index: true
    end

    execute "INSERT INTO action_partnerships (action_page_id, partner_id) \
    SELECT a.id, a.partner_id \
    FROM action_pages a \
    WHERE a.partner_id IS NOT NULL"

    remove_column :action_pages, :partner_id
  end

  def down
    add_reference :action_pages, :partner, index: true

    execute "INSERT INTO acction_pages (partner_id) \
    SELECT ap.partner_id \
    FROM action_partnerships ap \
    WHERE id = ap.action_page_id"

    drop_table :action_partnerships
  end
end


