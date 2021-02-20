class CreateComplaints < ActiveRecord::Migration[5.0]
  def change
    create_table :complaints do |t|
      t.string :email
      t.string :feedback_type
      t.string :user_agent
      t.json :body

      t.timestamps null: false
    end
  end
end
