class AddKitExpeInformationsToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :kit_expedition_status, :string
    add_column :bookings, :kit_expedition_link, :string
  end
end
