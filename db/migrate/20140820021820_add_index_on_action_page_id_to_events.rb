class AddIndexOnActionPageIdToEvents < ActiveRecord::Migration[5.0]
  def change
    add_index :ahoy_events, :action_page_id
  end
end
