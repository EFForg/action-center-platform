class RenameActionPagesIssueToActionPagesCategory < ActiveRecord::Migration[5.0]
  def change
    rename_column :action_pages, :issue, :category
  end
end
