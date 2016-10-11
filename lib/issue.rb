class Issue < Struct.new(:title)
  def self.all
    if enabled?
      YAML.load_file(config_file_path).sort.map{ |issue| new(issue) }
    else
      []
    end
  end

  def self.enabled?
    File.exist? config_file_path
  end

  private

  def self.config_file_path
    Rails.root.join("config/issues.yml")
  end
end
