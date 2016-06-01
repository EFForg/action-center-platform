class AddShowAllSignaturesToPetition < ActiveRecord::Migration
  def change
    add_column :petitions, :show_all_signatures, :boolean, default: false
  end
end
