class PartnersController < ApplicationController
  layout "admin"
  before_action :set_partner
  before_action :authenticate

  # GET /partners/1
  # GET /partners/1.json
  def show
    @subscriptions = @partner.subscriptions.
      paginate(page: params[:page], per_page: 10).
      order("id desc")
  end

  def csv
    send_data @partner.to_csv, filename: "eff_partner_emails.csv"
  end

  # PATCH/PUT /partners/1
  # PATCH/PUT /partners/1.json
  def update
    respond_to do |format|
      if @partner.update(partner_params)
        format.html { redirect_to @partner, notice: "Partner was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render "edit" }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_user
    user = User.find_by_email(params[:email])
    if user.nil?
      flash[:notice] = "Couldn't find a user by email #{params[:email]}"
    else
      if user.partner.nil?
        user.partner = @partner
        user.save
      elsif user.partner == @partner
        flash[:notice] = "That user is already linked to #{@partner.name}"
      else
        flash[:notice] = "That user is linked to another partner: #{user.partner.name}"
      end
    end
    redirect_to @partner
  end

  def remove_user
    user = User.find(params[:user_id])
    if user.partner == @partner
      user.partner = nil
      user.save
    else
      flash[:notice] = "That user is not linked to #{@partner.name}"
    end
    redirect_to @partner
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_partner
    @partner = Partner.find(params[:id])
  end

  def authenticate
    authenticate_user!
    unless current_user.admin?
      raise ActiveRecord::RecordNotFound if current_user.partner != @partner
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def partner_params
    params.require(:partner).permit(:name, :privacy_url, :code)
  end
end
