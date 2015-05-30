class ChangeSummaryToTextBlog < ActiveRecord::Migration
  def change
    change_column :action_pages, :summary, :text, :limit => nil
  end
end
