class AddCgvAgreementToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :cgv_agreement, :boolean, default: false
  end
end
