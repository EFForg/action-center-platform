class AddGoalToPetition < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :goal, :integer
  end
end
