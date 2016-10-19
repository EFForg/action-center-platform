class CreateCongressMembers < ActiveRecord::Migration
  def change
    create_table :congress_members do |t|
      t.string :full_name,   null: false
      t.string :first_name,  null: false
      t.string :last_name,   null: false
      t.string :bioguide_id, null: false
      t.string :twitter_id
      t.string :phone
      t.date   :term_end,    null: false
      t.string :chamber,     null: false
      t.string :state,       null: false
      t.integer :district

      t.timestamps
    end
  end
end
