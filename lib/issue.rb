class Issue < Struct.new(:title)
  def self.all
    if File.exist? Rails.root.join("config/issues.yml")
      YAML.load_file(Rails.root.join("config/issues.yml")).sort
    else
      []
    end
  end
end
