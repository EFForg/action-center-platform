class AddTemplateAndLayoutToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :template, :string
    add_column :action_pages, :layout, :string
  end
end
