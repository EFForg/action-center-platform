class AddCtaToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :cta, :string
  end
end
