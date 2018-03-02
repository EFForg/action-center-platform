class FeaturedActionPage < ActiveRecord::Base
  belongs_to :action_page
  validates_presence_of :action_page, :weight

  def initialize(attributes = {})
    super(attributes.reverse_merge(weight: 0))
  end
end
