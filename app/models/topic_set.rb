class TopicSet < ApplicationRecord
  belongs_to :topic_category
  has_many :topics, dependent: :destroy
end
