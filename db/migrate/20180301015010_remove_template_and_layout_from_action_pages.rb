class RemoveTemplateAndLayoutFromActionPages < ActiveRecord::Migration
  def change
    remove_column :action_pages, :template
    remove_column :action_pages, :layout
  end
end
