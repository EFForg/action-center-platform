module PetitionHelper
  def legislator_title(legislator)
    prefix = legislator.chamber == "senate" ? "Senator" : "Representative"
    [prefix, @legislator.last_name].join(" ")
  end

  def signature_location(signature)
    [signature.city, signature.state, signature.country_code].reject(&:blank?).join(", ")
  end
end
