class AddActionPageIdToAhoyEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :ahoy_events, :action_page_id, :integer
  end
end
