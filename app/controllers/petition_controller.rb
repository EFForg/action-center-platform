class PetitionController < ApplicationController
  before_action :set_petition
  before_action :ensure_show_all_allowed, only: :signatures

  def recent_signatures
    # signatories = @petition.recent_signatures(5)
    # signatures_total = @petition.signatures.count

    # render json: { signatories: signatories, signatures_total: signatures_total }
  end

  private

  def set_petition
    @petition = Petition.find(params[:id])
  end
end
