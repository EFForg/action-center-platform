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
    topics = topic_sets.order(:tier).reduce([]) do |arr, ts|
      arr += ts.topics
    end

    topics.each do |topic|
      t = topic.name.downcase.gsub(/\W/, "")

      options.each do |key, value|
        values = [
          key.downcase.gsub(/\W/, ""),
          value.try(:downcase).try(:gsub, /\W/, "")
        ].compact

        return (value || key) if values.include?(t)
      end
    end

    nil
  end
end
