class AddDbStatusToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :db_status, :string
  end
end
