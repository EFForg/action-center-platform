class CreateActionPages < ActiveRecord::Migration
  def change
    create_table :action_pages do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
