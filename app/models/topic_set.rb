class TopicSet < ActiveRecord::Base
  belongs_to :topic_category, touch: true
  has_many :topics, dependent: :destroy
end
