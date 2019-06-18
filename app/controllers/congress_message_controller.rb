class CongressMessageController < ApplicationController
  def lookup
    @members = CongressMember.lookup(params[street], params[zipcode])
    @forms = CongressForms::Form.find(@members.pluck(:bioguide_id))
    # @forms = CongressForms::Form.group_common_fields(forms)
    # @TODO address, message to template vars for form render, possibly hidden fields
  end

  def create
    # @TODO cache b/t requests? store locally?
    forms = CongressForms::Form.find(params[bioguide_ids])
    forms.each do |f|
      unless f.validate(congress_message_params)
        # Re-render form and return
      end
    end
    forms.each do |f|
      unless f.submit(congress_message_params)
        # re-render form and return
      end
    end
  end

  private

  def congress_message_params
  end
end
