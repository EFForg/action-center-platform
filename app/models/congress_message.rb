class CongressMessage
  include ActiveModel::Model
  validate :attributes_satisfy_forms

  attr_accessor :forms, :common_attributes, :member_attributes

  # @TODO no longer need to CSS hide these fields
  def self.new_from_lookup(location, message, campaign, forms)
    new({ common_attributes: {
            "$ADDRESS_STREET" => location.street,
            "$ADDRESS_CITY" => location.city,
            "$ADDRESS_ZIP4" => location.zip4,
            "$ADDRESS_ZIP5" => location.zipcode,
            "$STATE" => location.state,
            "$ADDRESS_STATE_POSTAL_ABBREV" => location.state,
            "$STATE" => location.state,
            "$MESSAGE" => message,
            "$SUBJECT" => campaign.subject
          },
          forms: forms })
  end

  def common_fields
    @common_fields ||= common_fields!
  end

  def common_fields!
    all_fields = @forms.reduce([]) { |a, b| a + b.fields }
    all_fields.select { |e| all_fields.count(e) > 1 }.uniq
  end

  def forms_minus_common_fields
    @forms.map do |form|
      form_minus = form.dup
      form_minus.fields = form.fields
        .reject { |x| common_fields.include?(x) }
      form_minus
    end
  end

  def targets
    forms.map(&:bioguide_id)
  end

  def attributes_for(bioguide_id)
    return common_attributes unless member_attributes && member_attributes[bioguide_id]
    common_attributes.merge(member_attributes[bioguide_id])
  end

  def attributes_satisfy_forms
    @forms.each do |form|
      attributes = attributes_for(form.bioguide_id)
      form.fields.each do |field|
        if !field.validate(attributes[field.value])
          errors.add(:base, "Invalid input for #{field.value}")
        end
      end
    end
  end

  def submit
    if valid?
      @forms.each { |f| f.fill(attributes_for(f.bioguide_id)) }
    end
  end
end
