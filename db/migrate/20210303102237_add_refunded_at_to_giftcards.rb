class AddRefundedAtToGiftcards < ActiveRecord::Migration[6.0]
  def change
    add_column :giftcards, :refunded_at, :date
  end
end
