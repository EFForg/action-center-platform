class CreateCallToolConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :call_tool_configs do |t|

      t.timestamps
    end
  end
end
