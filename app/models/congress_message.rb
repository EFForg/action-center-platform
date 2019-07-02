class CongressMessage
  include ActiveModel::Model
  validate :inputs_satisfy_forms

  attr_accessor :forms, :common_attributes, :member_attributes

  # @TODO no longer need to CSS hide these fields
  def self.new_from_lookup(location, message, forms)
    new({ common_attributes: {
            "$ADDRESS_STREET" => location.street,
            "$ADDRESS_CITY" => location.city,
            "$ADDRESS_ZIP4" => location.zip4,
            "$ADDRESS_ZIP5" => location.zipcode,
            # @TODO abbreviation expected here?
            # WHat forms can the state field take?
            "$STATE" => location.state,
            "$MESSAGE" => message
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

  def inputs_for(bioguide_id)
    common_attributes.merge(member_attributes[bioguide_id])
  end

  def inputs_satisfy_forms
    @forms.each do |form|
      inputs_for_form = inputs_for(form.bioguide_id)
      form.fields.each do |field|
        field.validate(inputs_for_form[field.value])
      end
    end
  end

  def submit
    if valid?
      # Check for success after each
      @forms.each { |f| f.fill(inputs_for(f.bioguide_id)) }
    end
  end
end
