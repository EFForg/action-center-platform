class AddGeoWorldMapTables < ActiveRecord::Migration
  def up
    create_table :countries, :id => false do |t|
      t.primary_key :CountryId
      t.string :name, :limit => 50, :null => false
      t.string :fips104, :limit => 2, :null => false
      t.string :iso2, :limit => 2, :null => false
      t.string :iso3, :limit => 3, :null => false
      t.string :ison, :limit => 4, :null => false
      t.string :internet, :limit => 2, :null => false
      t.string :capital, :limit => 25
      t.string :map_reference, :limit => 50
      t.string :nationality_singular, :limit => 35
      t.string :nationality_plural, :limit => 35
      t.string :currency, :limit => 30
      t.string :currency_code, :limit => 3
      t.integer :population
      t.string :title, :limit => 50
      t.string :comment, :limit => 255
    end
 
    create_table :regions, :id => false do |t|
      t.primary_key :RegionId
      t.references :country, :null => false
      t.string :name, :limit => 45, :null => false
      t.string :code, :limit => 8, :null => false
      t.string :adm1code, :limit => 4, :null => false
    end
 
    create_table :cities, :id => false do |t|
      t.primary_key :CityId
      t.references :country, :null => false
      t.references :region, :null => false
      t.string :name, :limit => 45, :null => false
      t.float :latitude, :null => false
      t.float :longitude, :null => false
      t.string :timezone, :limit => 10, :null => false
      t.integer :dma_id
      t.string :code, :limit => 4
    end
    add_index :countries, :name
    add_index :regions, :name
    add_index :cities, :name
 
    #change encoding to the one used into files
    execute "set client_encoding to 'latin1'"
    execute "COPY countries FROM '#{Rails.root}/db/migrate/Countries.txt' DELIMITER ',' CSV HEADER;"
    execute "COPY regions FROM '#{Rails.root}/db/migrate/Regions.txt' DELIMITER ',' CSV HEADER;"
    execute "COPY cities FROM '#{Rails.root}/db/migrate/Cities.txt' DELIMITER ',' CSV HEADER;"
    #change encoding back to UTF8
    execute "set client_encoding to 'UTF8'"
 
    rename_column :countries, 'CountryId', :id
    rename_column :regions, 'RegionId', :id
    rename_column :cities, 'CityId', :id
 
    #to generate foreign keys add
    #gem 'foreigner' into Gemfile
    add_foreign_key(:cities, :countries, :dependent => :delete)
    add_foreign_key(:cities, :regions, :dependent => :delete)
    add_foreign_key(:regions, :countries, :dependent => :delete)
  end
 
  def down
    drop_table :cities
    drop_table :regions
    drop_table :countries
  end
  def change
  end
end
