class SendReminderEmailJob < ApplicationJob
  queue_as :default

  def perform

    @sessions = Session.all.where(db_status: true).select {|s| s.reason.nil? && s.start_date == (Date.today + 1) }

    if @sessions
      @sessions.each do |s|
        s.bookings.where(db_status: true, status: "paid").each do |b|
          mail_reminder_btoc = BookingMailer.with(booking: b).reminder_booking_btoc
          mail_reminder_btoc.deliver_later
        end
      end
    end
    reschedule_job
  end

  def reschedule_job
    self.class.set(wait_until: Date.tomorrow.noon).perform_later
  end
end
