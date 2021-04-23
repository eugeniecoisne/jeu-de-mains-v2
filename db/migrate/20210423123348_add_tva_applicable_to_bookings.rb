class AddTvaApplicableToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :tva_applicable, :boolean
  end
end
