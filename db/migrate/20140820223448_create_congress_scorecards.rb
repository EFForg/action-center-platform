class CreateCongressScorecards < ActiveRecord::Migration
  def change
    create_table :congress_scorecards do |t|
      t.string :bioguide_id, required: true
      t.integer :action_page_id, required: true
      t.integer :counter, required: true, default: 0
    end
    add_index :congress_scorecards, [:action_page_id, :bioguide_id]
  end
end
