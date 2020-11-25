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
    @giftcard.code = "#{current_user.id}#{SecureRandom.hex(6)}"
    if @giftcard.save
      # envoi emails confirmation achat et PDF carte cadeau
      flash[:notice] = "Votre carte cadeau a bien été créée !"
      redirect_to giftcard_confirmation_achat_path(@giftcard)
    else
      render 'new'
    end
  end

  def update
  end

  def confirmation_achat
    @giftcard = Giftcard.find(params[:giftcard_id])
    authorize @giftcard
  end

  def confirmation_enregistrement
    @giftcard = Giftcard.find(params[:giftcard_id])
    authorize @giftcard
  end

  private

  def giftcard_params
    params.require(:giftcard).permit(:amount, :buyer, :buyer_name, :receiver, :receiver_name, :message, :status, :db_status)
  end

end
