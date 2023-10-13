class CreateTopic < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.string :name
      t.integer :topic_set_id
    end
  end
end
