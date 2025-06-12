class ChangeSummaryToTextBlog < ActiveRecord::Migration[5.0]
  def change
    change_column :action_pages, :summary, :text, :limit => nil
  end
end
