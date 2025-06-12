class CreateAhoyEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :ahoy_events, id: false do |t|
      t.uuid :id, primary_key: true, default: 'uuid_generate_v4()'
      t.uuid :visit_id

      # user
      t.integer :user_id
      # add t.string :user_type if polymorphic

      t.string :name
      t.json :properties
      t.timestamp :time
    end

    add_index :ahoy_events, [:visit_id]
    add_index :ahoy_events, [:user_id]
    add_index :ahoy_events, [:time]
  end
end
