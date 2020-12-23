class AddGiftcardPaymentToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :giftcard_id, :string
    add_column :bookings, :giftcard_amount_spent, :float
  end
end
