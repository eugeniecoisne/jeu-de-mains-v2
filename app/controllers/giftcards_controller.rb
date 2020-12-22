require 'securerandom'

class GiftcardsController < ApplicationController

  GIFTCARD_PRICES = {
    "20" => "price_1I1ESxHxDdHs6IJa0PzhihJq",
    "30" => "price_1I1ETbHxDdHs6IJaYJETGRRd",
    "40" => "price_1I1EU0HxDdHs6IJax3NQT4F5",
    "50" => "price_1I1EUWHxDdHs6IJasKiTB8Tf",
    "60" => "price_1I1EV6HxDdHs6IJamE9VHi3Q",
    "70" => "price_1I1EVfHxDdHs6IJa8nNqH1RA",
    "80" => "price_1I1EWEHxDdHs6IJa1uCGiVzl",
    "90" => "price_1I1EWnHxDdHs6IJaeHGTdVNT"
  }

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
    @giftcard.status = "pending"
    @giftcard.code = "#{current_user.id}#{SecureRandom.hex(6)}"

    key = "sk_test_51HxAxuHxDdHs6IJa1UTq9izcm9v0r2bECNyd0tk7Exyqj2puQ4mh29mxmfgxEWbpYzR4EKmwEaDLCiZOcSZXvTSo00SQ5LZktq"
    Stripe.api_key = key

    price = Stripe::Price.retrieve(GIFTCARD_PRICES["#{@giftcard.amount.to_i}"])

    customer = Stripe::Customer.create(email: current_user.email)

    current_user.update(stripe_id: customer.id)

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer: customer,
      line_items: [{
        price: price,
        quantity: 1
      }],
      mode: 'payment',
      success_url: mes_cartes_cadeaux_profile_url(current_user.profile),
      cancel_url: mes_cartes_cadeaux_profile_url(current_user.profile)
    )

    @giftcard.update(checkout_session_id: session.id)

    redirect_to new_giftcard_giftcard_payment_path(@giftcard)


    # if @giftcard.save
    #   # envoi emails confirmation achat et PDF carte cadeau
    #   flash[:notice] = "Votre carte cadeau a bien été créée !"
    #   redirect_to giftcard_confirmation_achat_path(@giftcard)
    # else
    #   render 'new'
    # end
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
