class RemoveCallToolConfigs < ActiveRecord::Migration[5.0]
  def change
    drop_table :call_tool_configs
  end
end
