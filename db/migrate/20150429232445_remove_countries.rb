class RemoveCountries < ActiveRecord::Migration
  def change
    drop_table :countries
  end
end
