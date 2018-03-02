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
end
