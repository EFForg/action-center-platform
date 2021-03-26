class AddPetitionIdToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :petition_id, :integer
  end
end
