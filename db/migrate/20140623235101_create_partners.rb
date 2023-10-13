class CreatePartners < ActiveRecord::Migration[5.0]
  def change
    create_table :partners do |t|
      t.string :code
      t.string :name
      t.string :privacy_url
      t.timestamps
    end
  end
end
