class AddAddressInfoAndPhoneNumberToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :address, :string
    add_column :bookings, :zip_code, :string
    add_column :bookings, :city, :string
    add_column :bookings, :phone_number, :string
  end
end
