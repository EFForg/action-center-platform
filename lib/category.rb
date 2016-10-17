class Category < Struct.new(:title)
  def self.all
    if enabled?
      YAML.load_file(config_file_path).sort.map{ |category| new(category) }
    else
      []
    end
  end

  def self.enabled?
    File.exist? config_file_path
  end

  private

  def self.config_file_path
    Rails.root.join("config/categories.yml")
  end
end
