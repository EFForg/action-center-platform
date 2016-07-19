class RemoveShowAllSignaturesFromPetition < ActiveRecord::Migration
  def change
    remove_column :petitions, :show_all_signatures, :boolean, default: false
  end
end
