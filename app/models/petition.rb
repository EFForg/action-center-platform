require 'csv'

class Petition < ActiveRecord::Base
  has_one :action_page
  has_many :signatures
  after_initialize :set_goal

  def percent_complete
    [signatures.count.to_f / goal.to_f, 1].min * 100
  end

  def recent_signatures(num)
    recent = []
    signatures.last(num).reverse.each do |s|
      if s.anonymous
        recent.push(s.as_json(:only => [], :methods => [:time_ago, :location]))
      else
        recent.push(s.as_json(:only => [:first_name, :last_name, :city], :methods => [:time_ago, :location]))
      end
    end
    recent
  end

  def to_csv(options = {})
    column_names =
      %w[first_name last_name email zipcode country_code created_at]
    CSV.generate(options) do |csv|
      csv << column_names
      signatures.each do |sub|
        csv << sub.attributes.values_at(*column_names)
      end
    end
  end

  def to_presentable_csv(options = {})
    column_names =
      %w[full_name email city state country]
    CSV.generate(options) do |csv|
      csv << column_names
      signatures.each do |signature|
        csv << signature.to_petition_csv_line
      end
    end
  end

  def to_s
    "#{title}-exported_on-#{DateTime.now.strftime("%Y-%m-%d")}"
  end

  private
  def set_goal
    if new_record?
      goal = 100
    end
  end
end
