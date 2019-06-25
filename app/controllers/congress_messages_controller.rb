class CongressMessagesController < ApplicationController
  def new
    @campaign = CongressMessageCampaign.find(params["congress_message_campaign_id"])

    # @address =
    @message = params["message"] # validate presence

    @members = CongressMember.lookup(street: params["street_address"],
                                     zipcode: params["zipcode"])
    @forms = CongressForms::Form.find(@members.pluck(:bioguide_id))
    @common = CongressForms::Form.common_fields(@forms)
    # Data prep
    #  - Filter out common
    #  - Sort all groups
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
