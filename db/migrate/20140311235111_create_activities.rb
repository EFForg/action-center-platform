class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :description

      t.timestamps
    end
  end
end
