class Admin::InstitutionSetsController < Admin::ApplicationController
  before_action :set_institution_set, only: [:show, :edit, :update, :destroy]
  before_action :set_active_tab

  # GET /admin/institution_sets
  def index
    @institution_sets = InstitutionSet.all
  end

  # GET /admin/institution_sets/1
  def show
  end

  # GET /admin/institution_sets/new
  def new
    @institution_set = InstitutionSet.new
  end

  # GET /admin/institution_sets/1/edit
  def edit
  end

  # POST /admin/institution_sets
  def create
    @institution_set = InstitutionSet.new(institution_set_params)

    respond_to do |format|
      if @institution_set.save
        format.html { redirect_to [:admin, @institution_set], notice: 'Institution set was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /admin/institution_sets/1
  def update
    respond_to do |format|
      if @institution_set.update(institution_set_params)
        format.html { redirect_to [:admin, @institution_set], notice: 'Institution set was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /admin/institution_sets/1
  def destroy
    @institution_set.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, :institution_sets] }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_institution_set
      @institution_set = InstitutionSet.find(params[:id])
    end

    def set_active_tab
      @institution_tab_active = 'active'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def institution_set_params
      params.require(:institution_set).permit(:name)
    end
end
