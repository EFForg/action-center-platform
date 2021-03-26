class CreateFeaturedActionPages < ActiveRecord::Migration[5.0]
  def change
    create_table :featured_action_pages do |t|
      t.integer :action_page_id
      t.integer :weight
    end
  end
end
