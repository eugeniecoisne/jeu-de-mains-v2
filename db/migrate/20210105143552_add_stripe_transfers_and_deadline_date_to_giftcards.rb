class AddStripeTransfersAndDeadlineDateToGiftcards < ActiveRecord::Migration[6.0]
  def change
    add_column :giftcards, :stripe_transfers, :text, default: ""
    add_column :giftcards, :deadline_date, :date
  end
end
