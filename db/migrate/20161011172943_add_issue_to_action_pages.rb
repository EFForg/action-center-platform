class AddIssueToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :issue, :string
  end
end
