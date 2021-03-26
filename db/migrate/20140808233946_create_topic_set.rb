class CreateTopicSet < ActiveRecord::Migration[5.0]
  def change
    create_table :topic_sets do |t|
      t.integer :tier
      t.integer :topic_category_id
    end
  end
end
