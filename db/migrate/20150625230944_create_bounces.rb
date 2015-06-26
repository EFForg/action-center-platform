class CreateBounces < ActiveRecord::Migration
  def change
    create_table :bounces do |t|
      t.string :email
    end
  end
end
