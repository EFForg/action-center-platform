module ActionCloner
  def self.run(original)
    clone = original.dup
    clone.published = false
    clone.victory = false
    clone.archived = false
    clone_tools(original, clone)
  end

  def self.clone_tools(original, clone)
    %i[tweet email_campaign petition congress_message_campaign].each do |tool_sym|
      clone.send("#{tool_sym}=", original.send(tool_sym).dup) if original.send("#{tool_sym}_id").present?
    end
    clone
  end
end
