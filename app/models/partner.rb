class Partner < ActiveRecord::Base
  acts_as_paranoid
  has_many :subscriptions
  has_many :users
  validates_uniqueness_of :code

  def to_csv(options = {})
    column_names = %w[first_name last_name email created_at]
    CSV.generate(options) do |csv|
      csv << column_names
      subscriptions.each do |sub|
        csv << sub.attributes.values_at(*column_names)
      end
    end
  end
end
