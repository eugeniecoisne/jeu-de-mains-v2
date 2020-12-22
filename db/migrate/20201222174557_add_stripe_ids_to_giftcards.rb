class AddStripeIdsToGiftcards < ActiveRecord::Migration[6.0]
  def change
    add_column :giftcards, :payment_intent_id, :string
    add_column :giftcards, :charge_id, :string
    add_column :giftcards, :refund_id, :string
    add_column :giftcards, :checkout_session_id, :string
  end
end
