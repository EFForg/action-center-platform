class AddSubscriptionsCountToPartners < ActiveRecord::Migration
  def up
    add_column :partners, :subscriptions_count, :integer, null: false, default: 0

    execute "UPDATE partners
             SET    subscriptions_count = subquery.subscriptions_count
             FROM   (SELECT   partners.id as partner_id, count(subscriptions.*) as subscriptions_count
                     FROM     partners LEFT JOIN subscriptions ON subscriptions.partner_id = partners.id
                     GROUP BY partners.id) AS subquery
             WHERE  partners.id = subquery.partner_id"
  end

  def down
    remove_column :partners, :subscriptions_count
  end
end
