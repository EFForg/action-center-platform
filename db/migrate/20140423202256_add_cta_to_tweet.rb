class AddCtaToTweet < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :cta, :string
  end
end
