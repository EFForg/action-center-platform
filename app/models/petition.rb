class Petition < ApplicationRecord
  has_one :action_page
  has_many :signatures
  after_initialize :set_goal

  def percent_complete
    return 0 if goal == 0

    [signatures.count / goal.to_f, 1].min * 100
  end

  def recent_signatures(num)
    recent = []
    signatures.last(num).reverse_each do |s|
      if s.anonymous
        recent.push(s.as_json(only: [], methods: %i[time_ago location]))
      else
        recent.push(s.as_json(only: %i[first_name last_name city], methods: %i[time_ago location]))
      end
    end
    recent
  end

  def signatures_by_institution(institution)
    signatures.includes(affiliations: :institution)
              .where(institutions: { id: institution })
  end

  def location_required?
    !enable_affiliations
  end

  def to_s
    "#{title}-exported_on-#{DateTime.now.strftime('%Y-%m-%d')}"
  end

  private

  def set_goal
    self.goal = 100 if new_record?
  end
end
