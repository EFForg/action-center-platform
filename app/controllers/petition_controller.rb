class PetitionController < ApplicationController
  def recent_signatures
    petition = Petition.find(params[:id])
    signatories = petition.recent_signatures(5)
    signatures_total = petition.signatures.count
    render json: {signatories: signatories, signatures_total: signatures_total}
  end
end
