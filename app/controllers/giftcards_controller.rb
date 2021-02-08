require 'securerandom'

class GiftcardsController < ApplicationController

  GIFTCARD_PRICES = {
    "20" => "price_1I6IFKHxDdHs6IJaiX4W3lGo",
    "30" => "price_1I6IGCHxDdHs6IJaIjJ0B0oh",
    "40" => "price_1I6IGoHxDdHs6IJa1aaAockR",
    "50" => "price_1I6IHOHxDdHs6IJa04G2uBgA",
    "60" => "price_1I6IHmHxDdHs6IJayuTVH3SH",
    "70" => "price_1I6IIDHxDdHs6IJaztx4DWOK",
    "80" => "price_1I6IIcHxDdHs6IJaK9wPpnpC",
    "90" => "price_1I6IJAHxDdHs6IJa9DwcRt5Z",
    "100" => "price_1I6IJgHxDdHs6IJat618000c",
    "110" => "price_1I6IK9HxDdHs6IJanmPc3c24",
    "120" => "price_1I6IKUHxDdHs6IJanNh8WW1C",
    "130" => "price_1I6IL3HxDdHs6IJauOvzUjXA",
    "140" => "price_1I6ILRHxDdHs6IJafDX666yl",
    "150" => "price_1I6ILrHxDdHs6IJaAJ8JqmNU"
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
    @giftcard.save

    key = "#{ENV['STRIPE_CONNECT_SECRET_KEY']}"
    Stripe.api_key = key

    price = Stripe::Price.retrieve(GIFTCARD_PRICES["#{@giftcard.amount.to_i}"])

    customer = Stripe::Customer.create(email: current_user.email)

    current_user.update(stripe_id: customer.id)

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer: customer,
      payment_intent_data: {
        transfer_group: "GIFTCARD_#{@giftcard.id}",
      },
      line_items: [{
        price: price,
        quantity: 1
      }],
      mode: 'payment',
      success_url: giftcard_confirmation_achat_url(@giftcard),
      cancel_url: new_giftcard_giftcard_payment_url(@giftcard)
    )

    @giftcard.update(checkout_session_id: session.id, deadline_date: (@giftcard.created_at + 1.year))
    CheckGiftcardStatusJob.set(wait: 45.minutes).perform_later(@giftcard)
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
    @giftcard = Giftcard.find(params[:id])
    authorize @giftcard
    @giftcard.update(giftcard_params)
  end

  def confirmation_achat
    @giftcard = Giftcard.find(params[:giftcard_id])
    if @giftcard.status == "paid"
      authorize @giftcard
    end
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "carte-jeu-de-mains-#{@giftcard.code}",
              margin:  { top:0,bottom:0,left:0,right:0}
      end
    end
  end

  def erreur_achat
    @giftcard = Giftcard.find(params[:giftcard_id])
    authorize @giftcard
  end

  def confirmation_enregistrement
    @giftcard = Giftcard.find(params[:giftcard_id])
    authorize @giftcard
  end

  private

  def giftcard_params
    params.require(:giftcard).permit(:amount, :code, :initial_amount, :buyer, :buyer_name, :receiver, :receiver_name, :message, :status, :db_status, :checkout_session_id, :payment_intent_id, :charge_id, :refund_id, :deadline_date, :transfers)
  end

end
