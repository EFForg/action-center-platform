class Admin::InstitutionsController < Admin::ApplicationController
  before_action :set_institution, only: %i(destroy edit update)
  before_action :set_categories, only: %i(new edit upload index)

  def index
    @institutions = Institution.includes(:action_pages).all.order(created_at: :desc)
    @institutions = @institutions.search(params[:q]) if params[:q].present?
    if params[:category].present? && params[:category] != "All"
      @institutions = @institutions.where(category: params[:category])
    end
    @institutions = @institutions.paginate(page: params[:page], per_page: 20)
  end

  def new
    @institution = Institution.new
  end

  def create
    @institution = Institution.find_or_initialize_by(institution_params)

    if @institution.save
      redirect_to action: "index", notice: "#{@institution.name} was successfully created."
    else
      render "new"
    end
  end

  def edit; end

  def update
    if @institution.update(institution_params)
      redirect_to action: "index", notice: "#{@institution.name} was successfully updated."
    else
      render "edit"
    end
  end

  def upload; end

  def import
    names = Institution.process_csv(params[:file])
    if names.empty?
      redirect_to action: "upload", notice: "Import failed. Please check CSV formatting"
    else
      category = if import_params[:new_category].blank?
                   import_params[:category]
                 else
                   import_params[:new_category]
                 end
      Institution.delay.import(category, names)
      redirect_to action: "index", notice: "Successfully imported #{names.length} targets"
    end
  end

  def destroy
    @institution.destroy
    redirect_to action: "index", notice: "Target deleted"
  end

  private

  def set_institution
    @institution = Institution.friendly.find(params[:id])
  end

  def set_categories
    @categories = Institution.categories
  end

  def institution_params
    params.require(:institution).permit(:name, :category, :slug)
  end

  def import_params
    params.require(:institutions).permit(:category, :new_category)
  end
end
