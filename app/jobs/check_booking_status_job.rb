class CheckBookingStatusJob < ApplicationJob
  queue_as :default

  def perform(booking)

    if booking.status == "pending"
      booking.update(db_status: false, status: nil)
    end
  end
end
