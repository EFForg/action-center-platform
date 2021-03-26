class RemoveUrlFromSourceFiles < ActiveRecord::Migration[5.0]
  def change
    remove_column :source_files, :url, :string
  end
end
