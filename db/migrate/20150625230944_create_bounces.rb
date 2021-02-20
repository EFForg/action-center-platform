class CreateBounces < ActiveRecord::Migration[5.0]
  def change
    create_table :bounces do |t|
      t.string :email
    end
  end
end
