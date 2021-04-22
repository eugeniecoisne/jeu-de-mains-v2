class SendAskReviewEmailJob < ApplicationJob
  queue_as :default

  def perform

    @sessions = Session.all.where(db_status: true, reason: nil).select {|s| ((s.end_date + 1.day) == Date.today) }

    if @sessions
      @sessions.each do |s|
        s.bookings.where(db_status: true, status: "paid").each do |b|
          mail_ask_review = BookingMailer.with(booking: b).ask_review_btoc
          mail_ask_review.deliver_later
        end
      end
    end
    reschedule_job
  end

  def reschedule_job
    self.class.set(wait_until: Date.tomorrow.noon).perform_later
  end
end
