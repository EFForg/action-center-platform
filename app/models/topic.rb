class Topic < ActiveRecord::Base
  belongs_to :topic_set, touch: true
end
