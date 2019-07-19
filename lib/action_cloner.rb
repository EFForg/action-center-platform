module ActionCloner
  def self.run(original)
    clone = original.dup
    clone.published = false
    clone.victory = false
    clone.archived = false
    clone_tools(original, clone)
  end

  private

  def self.clone_tools(original, clone)
    %i(tweet email_campaign petition congress_message_campaign call_campaign).each do |tool_sym|
      if original.send("#{tool_sym}_id").present?
        clone.send("#{tool_sym}=", original.send(tool_sym).dup)
      end
    end
    clone
  end
end
