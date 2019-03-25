class Admin::AffiliationTypesController < Admin::ApplicationController
  before_action :set_action_page
  before_action :set_affiliation_type, only: [:destroy]

  # GET /admin/affiliation_types
  def index
    @affiliation_types = @actionPage.affiliation_types
  end

  # GET /admin/affiliation_types/new
  def new
    @affiliation_type = @actionPage.affiliation_types.new
  end

  # POST /admin/affiliation_types
  def create
    @affiliation_type = AffiliationType.new(affiliation_type_params)
    @actionPage.affiliation_types << @affiliation_type

    respond_to do |format|
      if @affiliation_type.save
        format.html { redirect_to [:admin, @actionPage, AffiliationType], notice: "Affiliation type was successfully created." }
      else
        format.html { render "new" }
      end
    end
  end

  # DELETE /admin/affiliation_types/1
  def destroy
    @affiliation_type.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @actionPage, AffiliationType] }
    end
  end

  private

  def set_action_page
    @actionPage = ActionPage.friendly.find(params[:action_page_id])
    raise ActiveRecord::RecordNotFound unless @actionPage
  end

  def set_affiliation_type
    @affiliation_type = AffiliationType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def affiliation_type_params
    params.require(:affiliation_type).permit(:name, :action_page_id)
  end
end
