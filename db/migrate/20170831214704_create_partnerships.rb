class CreatePartnerships < ActiveRecord::Migration
  def up
    create_table :partnerships do |t|
      t.belongs_to :action_page, index: true
      t.belongs_to :partner, index: true
    end

    execute "INSERT INTO partnerships (action_page_id, partner_id) \
    SELECT a.id, a.partner_id \
    FROM action_pages a \
    WHERE a.partner_id IS NOT NULL"

    remove_column :action_pages, :partner_id
  end

  def down
    add_reference :action_pages, :partner, index: true

    execute "INSERT INTO action_pages (partner_id) \
    SELECT p.partner_id \
    FROM partnerships p \
    WHERE id = p.action_page_id"

    drop_table :partnerships
  end
end


