class ChangeComplaintBodyFormat < ActiveRecord::Migration
  def up
    change_column :complaints, :body, :jsonb
  end

  def down
    change_column :complaints, :body, :json
  end
end
