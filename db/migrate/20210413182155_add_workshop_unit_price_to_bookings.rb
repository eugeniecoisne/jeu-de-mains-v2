class AddWorkshopUnitPriceToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :workshop_unit_price, :float
  end
end
