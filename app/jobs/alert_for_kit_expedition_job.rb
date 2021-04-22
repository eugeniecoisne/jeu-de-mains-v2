class AlertForKitExpeditionJob < ApplicationJob
  queue_as :default

  def perform

    @sessions = Session.all.where(db_status: true, reason: nil).select {|s| s.workshop.kit == true && s.workshop.db_status == true && s.workshop.status == "en ligne" && ((s.start_date - 6.days) == Date.today) }

    if @sessions
      @sessions.each do |s|
        if s.bookings.where(db_status: true, status: "paid").present?
          mail_send_kits = SessionMailer.with(session: s).send_kits_alert
          mail_send_kits.deliver_later
        end
      end
    end
    reschedule_job
  end

  def reschedule_job
    # finalement ça envoie le matin de J-6 avant l'atelier.
    self.class.set(wait_until: Date.tomorrow.midnight).perform_later
  end
end
