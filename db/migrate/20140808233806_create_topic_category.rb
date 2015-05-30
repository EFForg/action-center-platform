class CreateTopicCategory < ActiveRecord::Migration
  def change
    create_table :topic_categories do |t|
      t.string :name
    end
  end
end
