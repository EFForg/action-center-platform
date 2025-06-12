module Quotes
  def self.get
    quotes.sample
  end

  def self.quotes
    @quotes ||= YAML.load_file("config/custom_quotes.yml")
  rescue Errno::ENOENT
    @quotes ||= YAML.load_file("config/quotes.yml")
  end
end
