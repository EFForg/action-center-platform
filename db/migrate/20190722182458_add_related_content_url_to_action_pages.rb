class AddRelatedContentUrlToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :related_content_url, :string
  end
end
