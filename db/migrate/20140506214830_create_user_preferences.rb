class CreateUserPreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :user_preferences do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :value
      t.timestamps
    end
  end
end
