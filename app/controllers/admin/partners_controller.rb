class Admin::PartnersController < Admin::ApplicationController
  layout "admin"

  before_action :set_partner, only: %i(edit update show destroy)

  # GET /partners
  # GET /partners.json
  def index
    @partners = Partner.order(:name).paginate(page: params[:page])
  end

  # GET /partners/new
  def new
    @partner = Partner.new
  end

  # POST /partners
  # POST /partners.json
  def create
    @partner = Partner.new(partner_params)

    respond_to do |format|
      if @partner.save
        format.html { redirect_to @partner, notice: "Partner was successfully created." }
        format.json { render "show", status: :created, location: @partner }
      else
        format.html { render "new" }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @partner.update(partner_params)
      redirect_to @partner, notice: "Partner was successfully updated"
    else
      render "edit"
    end
  end

  # DELETE /partners/1
  # DELETE /partners/1.json
  def destroy
    @partner.destroy
    respond_to do |format|
      format.html { redirect_to admin_partners_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # Never trust parameters from the scary internet, only allow the white list through.
  def partner_params
    params.require(:partner).permit(:name, :privacy_url, :code)
  end

  def set_partner
    @partner = Partner.find(params[:id])
  end
end
