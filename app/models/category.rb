class Category < ActiveRecord::Base
  validates_presence_of :title
  validates_format_of :title, with: /\A[\w\s&]+\Z/
end
