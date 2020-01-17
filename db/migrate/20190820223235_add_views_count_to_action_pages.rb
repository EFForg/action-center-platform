class AddViewsCountToActionPages < ActiveRecord::Migration[5.0]
  def self.up
    add_column :action_pages, :view_count, :integer, null: false, default: 0
    add_column :action_pages, :action_count, :integer, null: false, default: 0
    pages = exec_query("SELECT id FROM action_pages")
    pages.each do |id|
      id = id["id"]
      views = exec_query("SELECT COUNT(id) FROM ahoy_events "\
                         "WHERE action_page_id = #{id} AND name = 'View'")
      action = exec_query("SELECT COUNT(id) FROM ahoy_events "\
                          "WHERE action_page_id = #{id} AND name = 'Action'")
      execute("UPDATE action_pages "\
              "SET view_count = #{views[0]["count"]}, "\
              "action_count = #{action[0]["count"]} "\
              "WHERE id = #{id}")
    end
  end

  def self.down
    remove_column :action_pages, :view_count
    remove_column :action_pages, :action_count
  end
end
