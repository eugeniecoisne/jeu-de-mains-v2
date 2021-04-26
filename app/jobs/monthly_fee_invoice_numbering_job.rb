class MonthlyFeeInvoiceNumberingJob < ApplicationJob
  queue_as :default

  def perform

    # avant d'envoyer par e-mail les factures de commission le premier jour du mois suivant à midi,
    # on détermine ici le numéro de facture grâce à un id de FeeInvoice
    # cette action a lieu le premier jour du mois suivant à minuit donc avant envoi des e-mails de midi.

    bookings_of_month = []
    Booking.all.where(db_status: true).select { |b| b.status == "paid" || b.status == "refunded"}.each do |b|
      if b.cancelled_at.present? && b.cancelled_at >= (Date.today - 10.days).at_beginning_of_month && b.cancelled_at <= (Date.today - 10.days).end_of_month
        bookings_of_month << b
      elsif b.created_at >= (Date.today - 10.days).at_beginning_of_month && b.created_at <= (Date.today - 10.days).end_of_month
        bookings_of_month << b
      end
    end

    if bookings_of_month.size > 0
      active_partners = bookings_of_month.map { |b| b.session.workshop.place.user.profile }.uniq
      active_partners.sort.each do |p|
        FeeInvoice.create(profile_id: p.id, start_date: (Date.today - 10.days).at_beginning_of_month, end_date: (Date.today - 10.days).end_of_month)
      end
    end
    reschedule_job
  end

  def reschedule_job
    self.class.set(wait_until: (Date.today + 1.month).midnight).perform_later
  end
end
