class Partner < ActiveRecord::Base
  acts_as_paranoid
  has_many :subscriptions
  has_many :users
  has_many :partnerships
  has_many :action_pages, through: :partnerships
  validates_uniqueness_of :code

  after_save :touch_action_pages

  def to_csv(options = {})
    column_names = %w[first_name last_name email created_at]
    CSV.generate(options) do |csv|
      csv << column_names
      subscriptions.each do |sub|
        csv << sub.attributes.values_at(*column_names)
      end
    end
  end

  def touch_action_pages
    action_pages.update_all(updated_at: Time.now)
  end
end
