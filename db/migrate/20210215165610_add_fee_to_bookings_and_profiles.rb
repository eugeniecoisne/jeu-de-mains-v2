class AddFeeToBookingsAndProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :fee, :float, default: 0.2
    add_column :bookings, :fee, :float, default: 0.2
  end
end
