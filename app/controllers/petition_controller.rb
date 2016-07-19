class PetitionController < ApplicationController
  before_filter :set_petition
  before_filter :ensure_show_all_allowed, only: :signatures

  def recent_signatures
    signatories = @petition.recent_signatures(5)
    signatures_total = @petition.signatures.count
    render json: {signatories: signatories, signatures_total: signatures_total}
  end

  def signatures
    respond_to do |format|
      format.csv do
        send_data @petition.to_csv()
      end
    end
  end

  private

  def set_petition
    @petition = Petition.find(params[:id])
  end

  def ensure_show_all_allowed
    unless @petition.show_all_signatures
      raise ActiveRecord::RecordNotFound
    end
  end

end