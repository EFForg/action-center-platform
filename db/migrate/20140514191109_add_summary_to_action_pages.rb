class AddSummaryToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :summary, :string
  end
end
