# The CongressScorecard creates a card for a member of congress for each
# petition action that drew in a signature from one of their constituents
# So calling #counter on a model will display the number of signatures from
# that member's constituents
class CongressScorecard < ActiveRecord::Base
  belongs_to :action_page

  def increment!
    CongressScorecard.increment_counter(:counter, id) # Increments counter atomically
  end
end
