require 'securerandom'

class GiftcardsController < ApplicationController

  GIFTCARD_PRICES = {
    "20" => "price_1In3LrHxDdHs6IJawLPNUHYU",
    "30" => "price_1In3M9HxDdHs6IJakhX45g2e",
    "40" => "price_1In3MEHxDdHs6IJaIGYN85XV",
    "50" => "price_1In3MZHxDdHs6IJamUxLtDqh",
    "60" => "price_1In3MgHxDdHs6IJax54SYRth",
    "70" => "price_1In3MmHxDdHs6IJa2v6eHFN6",
    "80" => "price_1In3MsHxDdHs6IJaTmtJzkrF",
    "90" => "price_1In3MxHxDdHs6IJaPmUb4iDz",
    "100" => "price_1In3N1HxDdHs6IJaJ4LzY28y",
    "110" => "price_1In3N6HxDdHs6IJaR1YhQs4M",
    "120" => "price_1In3NBHxDdHs6IJaQEmSfHwJ",
    "130" => "price_1In3NFHxDdHs6IJasGopIf7b",
    "140" => "price_1In3NKHxDdHs6IJalJwf0dxD",
    "150" => "price_1In3NOHxDdHs6IJaU6LHSBF1"
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
    Stripe.api_version = '2020-08-27'

    price = Stripe::Price.retrieve(GIFTCARD_PRICES["#{@giftcard.amount.to_i}"])

    customer = Stripe::Customer.create(email: current_user.email)

    current_user.update(stripe_id: customer.id)

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer: customer,
      payment_intent_data: {
        transfer_group: "GIFTCARD_#{@giftcard.id}",
        metadata: {
          jdm_type: "giftcard",
          jdm_id: @giftcard.id,
          jdm_user_id: current_user.id
        },
      },
      line_items: [{
        price: price,
        quantity: 1
      }],
      mode: 'payment',
      success_url: giftcard_confirmation_achat_url(@giftcard),
      cancel_url: giftcard_erreur_achat_url(@giftcard)
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
    authorize @giftcard
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "carte-cadeau-jdm-#{@giftcard.code}",
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

  # refund a giftcard
  def destroy
    @giftcard = Giftcard.find(params[:id])
    authorize @giftcard

    # vérifier que la giftcard amount est tjs = au initial amount donc inutilisée
    key = "#{ENV['STRIPE_CONNECT_SECRET_KEY']}"
    Stripe.api_key = key
    Stripe.api_version = '2020-08-27'

    refund = Stripe::Refund.create({
      payment_intent: @giftcard.payment_intent_id,
    })
    @giftcard.update(refund_id: refund.id, charge_id: refund.charge, refunded_at: Time.now, status: 'refunded')
    @giftcard.save

    flash[:notice] = "La carte cadeau #{@giftcard.id} a bien été remboursée."
    redirect_back fallback_location: root_path
    # prévenir par e-mail manuellement ensuite si le remboursement a bien été effectué sur stripe
  end

  private

  def giftcard_params
    params.require(:giftcard).permit(:amount, :code, :initial_amount, :buyer, :buyer_name, :receiver, :receiver_name, :message, :status, :db_status, :checkout_session_id, :payment_intent_id, :charge_id, :refund_id, :deadline_date, :transfers, :cgv_agreement)
  end

end
