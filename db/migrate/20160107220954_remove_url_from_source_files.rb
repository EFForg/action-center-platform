class RemoveUrlFromSourceFiles < ActiveRecord::Migration
  def change
    remove_column :source_files, :url, :string
  end
end
