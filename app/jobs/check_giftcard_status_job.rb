class CheckGiftcardStatusJob < ApplicationJob
  queue_as :default

  def perform(giftcard)

    if giftcard.status == "pending"
      giftcard.update(db_status: false, status: nil)
    end
  end
end
