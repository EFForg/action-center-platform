class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :target
      t.string :message
    end
  end
end
