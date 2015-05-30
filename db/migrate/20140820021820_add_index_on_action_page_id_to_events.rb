class AddIndexOnActionPageIdToEvents < ActiveRecord::Migration
  def change
    add_index :ahoy_events, :action_page_id
  end
end
