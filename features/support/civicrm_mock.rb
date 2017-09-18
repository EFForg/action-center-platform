require "civicrm"

module CiviCRM
  module UserMethods
    def contact_id!
      nil
    end

    def subscribe!(opt_in=false, source='action center')
      nil
    end
  end

  private
  # Instead of posting to CiviCRM,
  # we store posts in memory so we can query them in our tests.
  def self.post(params)
    subscriptions.push(params)
  end
  
  def self.subscriptions
    @subscriptions ||= []
  end

  def self.clear_subscriptions
    @subscriptions = []
  end
end


After do
  CiviCRM::clear_subscriptions
end
