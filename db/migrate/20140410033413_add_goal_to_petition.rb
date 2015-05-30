class AddGoalToPetition < ActiveRecord::Migration
  def change
    add_column :petitions, :goal, :integer
  end
end
