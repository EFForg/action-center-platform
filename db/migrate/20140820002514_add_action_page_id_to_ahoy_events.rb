class AddActionPageIdToAhoyEvents < ActiveRecord::Migration
  def change
    add_column :ahoy_events, :action_page_id, :integer
  end
end
