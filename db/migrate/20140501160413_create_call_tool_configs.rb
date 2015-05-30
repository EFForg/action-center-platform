class CreateCallToolConfigs < ActiveRecord::Migration
  def change
    create_table :call_tool_configs do |t|

      t.timestamps
    end
  end
end
