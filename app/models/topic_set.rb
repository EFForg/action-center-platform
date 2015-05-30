class TopicSet < ActiveRecord::Base
  belongs_to :topic_category
  has_many :topics, dependent: :destroy
end
