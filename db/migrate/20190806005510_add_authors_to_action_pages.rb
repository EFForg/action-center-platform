class AddAuthorsToActionPages < ActiveRecord::Migration[5.0]
  def change
    change_table :action_pages do |t|
      t.belongs_to :user, null: true
    end
  end
end
