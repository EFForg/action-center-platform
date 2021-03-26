class RemoveShowAllSignaturesFromPetition < ActiveRecord::Migration[5.0]
  def change
    remove_column :petitions, :show_all_signatures, :boolean, default: false
  end
end
