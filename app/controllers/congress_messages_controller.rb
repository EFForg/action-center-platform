class CongressMessagesController < ApplicationController
  def new
    @members = CongressMember.lookup(street: params["street_adress"],
                                     zipcode: params["zipcode"])
    @forms = CongressForms::Form.find(@members.pluck(:bioguide_id))
    @common = CongressForms::Form.common_fields(@forms)
    # @TODO address, message to template vars for form render, possibly hidden fields
    render partial: "form"
  end

  def create
    # @TODO avoid repeating this request?
    forms = CongressForms::Form.find(params[bioguide_ids])
    forms.each do |f|
      unless f.validate(params)
        # Re-render form and return
      end
    end
    forms.each do |f|
      unless f.submit(params)
        # re-render form and return
      end
    end
  end
end
