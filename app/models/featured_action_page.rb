class FeaturedActionPage < ApplicationRecord
  belongs_to :action_page
  validates :action_page, :weight, presence: true

  def initialize(attributes = {})
    super(attributes.reverse_merge(weight: 0))
  end

  def self.load_for_edit
    existing = order(:weight).preload(:action_page)
    return existing unless existing.length < 4

    weights_to_create = (1..4).to_a - existing.map(&:weight)
    existing + weights_to_create.map { |w| new(weight: w) }
  end
end
