class CongressScorecard < ActiveRecord::Base
  belongs_to :action_page

  def increment!
    CongressScorecard.increment_counter(:counter, id) # Increments counter atomically
  end
end
