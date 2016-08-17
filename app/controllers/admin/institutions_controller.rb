class Admin::InstitutionsController < Admin::ApplicationController
  before_filter :set_action_page
  before_action :set_institution, only: [:destroy]

  require 'csv'

  # GET /admin/action_pages/:action_page_id/institutions
  def index
    @institutions = @actionPage.institutions.order(:name).page(params[:page])
  end

  # GET /admin/action_pages/:action_page_id/institutions/new
  def new
    @institution = @actionPage.institutions.new
  end

  # POST /admin/action_pages/:action_page_id/institutions
  def create
    @institution = Institution.find_or_initialize_by(name: institution_params[:name])
    @actionPage.institutions << @institution

    respond_to do |format|
      if @institution.save
        format.html { redirect_to [:admin, @actionPage, Institution], notice: 'Institution was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # POST /admin/action_pages/:action_page_id/institutions/import
  def import
    names = []
    CSV.foreach(params[:file].path, headers: true) do |row|
      params = row.to_hash
      unless params['name']
        flash[:notice] = 'Import failed. Please check CSV formatting'
        break
      end
      names << params['name']
    end

    Institution.delay.import(names, @actionPage)

    redirect_to [:admin, @actionPage, Institution]
  end

  # DELETE /admin/action_pages/:action_page_id/institutions/1/
  def destroy
    @actionPage.institutions.delete(@institution)
    respond_to do |format|
      format.html { redirect_to [:admin, @actionPage, Institution] }
    end
  end

  # DELETE /admin/action_pages/:action_page_id/institutions/
  def destroy_all
    @actionPage.institutions.delete_all
    respond_to do |format|
      format.html { redirect_to [:admin, @actionPage, Institution] }
    end
  end

  private
    def set_action_page
      @actionPage = ActionPage.friendly.find(params[:action_page_id])
      raise ActiveRecord::RecordNotFound unless @actionPage
    end

    def set_institution
      @institution = Institution.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def institution_params
      params.require(:institution).permit(:name, :action_page_id)
    end
end
