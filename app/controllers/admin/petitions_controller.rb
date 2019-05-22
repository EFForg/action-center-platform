include PetitionHelper
class Admin::PetitionsController < Admin::ApplicationController
  before_action :set_petition

  allow_collaborators_to :show, :destroy_signatures

  def show
    @search_params = search_params
    @signatures = filtered_signatures
  end

  # This file will wind up at CiviCRM
  def csv
    send_data @petition.to_csv
  end

  # this csv file is just for activists, they tender them to legislators after vetting
  def presentable_csv
    filename = sanitize_filename("#{@petition}.csv")
    send_data @petition.to_presentable_csv, filename: filename
  end

  def destroy_signatures
    @petition.signatures.where(id: params[:signature_ids]).delete_all

    if params[:page].to_i > filtered_signatures.total_pages
      params[:page] = filtered_signatures.total_pages
    end

    redirect_to admin_petition_path(@petition, search_params)
  end

  private

  def set_petition
    @petition = Petition.find(params[:id])
  end

  def filtered_signatures
    @petition.signatures.
      filter(params[:query]).
      order(created_at: :desc).
      paginate(page: params[:page], per_page: params[:per_page] || 10)
  end

  def search_params
    params.permit(:query, :page, :per_page).to_h
  end
end
