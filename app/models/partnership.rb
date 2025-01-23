class Partnership < ApplicationRecord
  belongs_to :partner
  belongs_to :action_page
end
