# CongressMessage describes a submission to the Congress Message tool.
# It isn't backed by the database.
class CongressMessage
  include ActiveModel::Model
  validate :attributes_satisfy_forms

  attr_accessor :forms, :campaign
  attr_writer :common_attributes, :member_attributes

  ALWAYS_COMMON = %w($NAME_FIRST $NAME_LAST $ADDRESS_CITY $ADDRESS_STATE
                     $ADDRESS_STREET $ADDRESS_ZIP5 $EMAIL).freeze

  def common_attributes() @common_attributes || {}; end
  def member_attributes() @member_attributes || {}; end

  def self.new_from_lookup(location, campaign, forms)
    common_attributes = {
      "$MESSAGE" => campaign.message,
      "$SUBJECT" => campaign.subject
    }
    if location
      common_attributes.merge!({
        "$ADDRESS_STREET" => location.street,
        "$ADDRESS_CITY" => location.city,
        "$ADDRESS_ZIP4" => location.zip4,
        "$ADDRESS_ZIP5" => location.zipcode,
        "$ADDRESS_STATE" => location.state,
        "$ADDRESS_STATE_POSTAL_ABBREV" => location.state
      })
    end
    new({ common_attributes: common_attributes, forms: forms, campaign: campaign })
  end

  def common_fields
    @common_fields ||= common_fields!
  end

  def common_fields!
    all_fields = @forms.reduce([]) { |a, b| a + b.fields }
    always_common = all_fields.select { |f| ALWAYS_COMMON.include? f.value }
    (all_fields.select { |e| all_fields.count(e) > 1 } + always_common).uniq
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
    return common_attributes unless member_attributes[bioguide_id]
    common_attributes.merge(member_attributes[bioguide_id])
  end

  def background_submit(test = false)
    if valid?
      @forms.each { |f| f.delay.fill(attributes_for(f.bioguide_id), campaign.campaign_tag, test) }
    end
  end

  def update_common_attributes(**attrs)
    member_attributes.each_value do |member_attrs|
      attrs.each { |key, val| member_attrs[key.to_s] = val }
    end
  end

  private

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
end
