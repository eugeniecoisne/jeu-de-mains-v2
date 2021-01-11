class AddChargeRefundPaymentIntentToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :payment_intent_id, :string
    add_column :bookings, :charge_id, :string
    add_column :bookings, :refund_id, :string
  end
end
