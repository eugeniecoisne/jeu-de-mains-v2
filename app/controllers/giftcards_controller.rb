require 'securerandom'

class GiftcardsController < ApplicationController

  def show
    @giftcard = Giftcard.find(params[:id])
    authorize @giftcard
  end

  def new
    if params[:giftcard][:amount].present?
      @giftcard = Giftcard.new
      @giftcard.amount = params[:giftcard][:amount].first(3).to_f
      authorize @giftcard
    end
  end

  def create
    @giftcard = Giftcard.new(giftcard_params)
    authorize @giftcard
    @giftcard.user = current_user
    @giftcard.code = "#{current_user.id}#{SecureRandom.urlsafe_base64(15)}"
    if @giftcard.save
      # envoi emails confirmation achat et PDF carte cadeau
      flash[:notice] = "Votre carte cadeau a bien été créée !"
      redirect_to giftcard_path(@giftcard)
    else
      render 'new'
    end
  end

  def update
    @giftcard.update(giftcard_params)
    if @giftcard.save
      flash[:notice] = "Votre carte cadeau a bien été ajoutée !"
      redirect_to tableau_de_bord_profile_path(current_user.profile)
    else
      flash[:alert] = "Votre carte cadeau n'a pas pu être ajoutée. Réessayez et contactez-nous si besoin."
      redirect_to tableau_de_bord_profile_path(current_user.profile)
    end
  end

  private

  def giftcard_params
    params.require(:giftcard).permit(:amount, :buyer, :buyer_name, :receiver, :receiver_name, :message, :status, :db_status)
  end

end
