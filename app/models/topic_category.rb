class TopicCategory < ActiveRecord::Base
  has_many :topic_sets, dependent: :destroy
  has_many :email_campaigns
  has_many :congress_message_campaigns

  def as_2d_array
    arr = []
    topic_sets.order(:tier).each do |ts|
      arr.push ts.topics.map { |t| t.name }
    end
    arr
  end

  def best_match(options)
    alphanum = options.map { |x| x.downcase.gsub(/\W/, "") }
    topics = topic_sets.order(:tier).reduce([]) do |arr, ts|
      arr += ts.topics.map { |t| t.name.downcase.gsub(/\W/, "") }
    end
    # Order is preserved from the first array
    match = (topics & alphanum).first
    options[alphanum.index(match)] if match != nil
  end
end
