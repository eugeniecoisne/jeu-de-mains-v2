class AddStripeGiftcardTransferAndCancelledAtToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :stripe_giftcard_transfer, :string
    add_column :bookings, :cancelled_at, :date

  end
end
