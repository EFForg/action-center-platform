class AddSummaryToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :summary, :string
  end
end
