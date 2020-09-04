class ChangeDbStatusToBeBooleanInBookings < ActiveRecord::Migration[6.0]
  def change
    change_column :bookings, :db_status, :boolean, using: 'db_status::boolean', default: true
  end
end
