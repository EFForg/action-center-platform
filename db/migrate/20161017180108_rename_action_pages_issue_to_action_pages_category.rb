class RenameActionPagesIssueToActionPagesCategory < ActiveRecord::Migration
  def change
    rename_column :action_pages, :issue, :category
  end
end
