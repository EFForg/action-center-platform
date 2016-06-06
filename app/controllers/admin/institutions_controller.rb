class Admin::InstitutionsController < Admin::ApplicationController
  before_filter :set_institution_set
  before_action :set_institution, only: [:edit, :update, :destroy]
  before_action :set_active_tab

  # GET /admin/institution_sets/:institution_set_id/institutions/new
  def new
    @institution = @institution_set.institutions.new
  end

  # GET /admin/institution_sets/:institution_set_id/institutions/1/edit
  def edit
  end

  # POST /admin/institution_sets/:institution_set_id/institutions
  def create
    @institution = @institution_set.institutions.new(institution_params)

    respond_to do |format|
      if @institution.save
        format.html { redirect_to [:admin, @institution_set], notice: 'Institution was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /admin/institution_sets/:institution_set_id/institutions/1
  def update
    respond_to do |format|
      if @institution.update(institution_params)
        format.html { redirect_to [:admin, @institution_set], notice: 'Institution was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /admin/institution_sets/:institution_set_id/institutions/1
  def destroy
    @institution.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @institution_set] }
    end
  end

  private
    def set_institution_set
      @institution_set = InstitutionSet.find(params[:institution_set_id])
    end

    def set_institution
      @institution = Institution.find(params[:id])
    end

    def set_active_tab
      @institution_tab_active = 'active'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def institution_params
      params.require(:institution).permit(:name, :institution_set_id)
    end
end
