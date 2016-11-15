class AddCollaboratorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :collaborator, :boolean, null: false, default: false
  end
end
