class CreateSignatures < ActiveRecord::Migration
  def change
    create_table :signatures do |t|
      t.integer :petition_id
      t.integer :user_id

      t.timestamps
    end
  end
end
