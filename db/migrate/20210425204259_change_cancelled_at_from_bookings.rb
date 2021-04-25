class ChangeCancelledAtFromBookings < ActiveRecord::Migration[6.0]
  def change
    change_column :bookings, :cancelled_at, :datetime
  end
end
