class Partnership < ActiveRecord::Base
  belongs_to :partner
  belongs_to :action_page, touch: true
end
