class UpdateRefundRateInBookings < ActiveRecord::Migration[6.0]
  def change
    change_column :bookings, :refund_rate, :float, default: 1.0
  end
end
