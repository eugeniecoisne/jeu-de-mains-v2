class GiftcardPaymentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(new)

  def new
    @giftcard = current_user.giftcards.where(status: 'pending').find(params[:giftcard_id])
    authorize @giftcard
  end
end
