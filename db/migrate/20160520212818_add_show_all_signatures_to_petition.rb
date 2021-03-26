class AddShowAllSignaturesToPetition < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :show_all_signatures, :boolean, default: false
  end
end
