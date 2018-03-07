class PetitionController < ApplicationController
  before_filter :set_petition
  before_filter :ensure_show_all_allowed, only: :signatures

  def recent_signatures
    signatories = @petition.recent_signatures(5)
    signatures_total = @petition.signatures.count

    response.headers["Cache-Control"] = "public, no-cache"
    response.headers["Surrogate-Control"] = "max-age=60"

    render json: { signatories: signatories, signatures_total: signatures_total }
  end

  private

  def set_petition
    @petition = Petition.find(params[:id])
  end
end
