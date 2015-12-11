class RemoveCallToolConfigs < ActiveRecord::Migration
  def change
    drop_table :call_tool_configs
  end
end
