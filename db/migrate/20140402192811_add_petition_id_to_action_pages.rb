class AddPetitionIdToActionPages < ActiveRecord::Migration
  def change
    add_column :action_pages, :petition_id, :integer
  end
end
