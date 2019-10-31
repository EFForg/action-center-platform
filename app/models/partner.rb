class Partner < ActiveRecord::Base
  extend AmazonCredentials
  acts_as_paranoid
  has_many :subscriptions
  has_many :users
  has_many :partnerships
  has_many :action_pages, through: :partnerships
  has_attached_file :logo, amazon_credentials

  validates_media_type_spoof_detection :logo,
    if: -> { logo.present? && logo_file_name_came_from_user? }
  do_not_validate_attachment_file_type [:logo]
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
