class AddTemplateAndLayoutToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :template, :string
    add_column :action_pages, :layout, :string
  end
end
