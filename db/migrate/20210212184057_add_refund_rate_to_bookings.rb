class AddRefundRateToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :refund_rate, :float
  end
end
