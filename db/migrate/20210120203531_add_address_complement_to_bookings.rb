class AddAddressComplementToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :address_complement, :string
  end
end
