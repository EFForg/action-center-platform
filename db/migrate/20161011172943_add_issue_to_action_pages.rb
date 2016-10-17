class AddIssueToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :issue, :string
  end
end
