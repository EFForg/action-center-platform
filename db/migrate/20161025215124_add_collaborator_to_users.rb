class AddCollaboratorToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :collaborator, :boolean, null: false, default: false
  end
end
