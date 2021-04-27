class WeeklySendPartnerClientInvoicesJob < ApplicationJob
  queue_as :default

  def perform

    Profile.all.where(db_status: true).select { |p| p.role.present? && p.ready == true }.each do |p|
      @refunded_bookings = []
      @new_bookings = []
      Booking.all.where(db_status: true).select { |b| b.status == "paid" || b.status == "refunded"}.select { |b| b.session.workshop.place.user.profile == p }.each do |b|
        if b.status == "refunded"
        # Vérifier que l'annulation de la réservation a eu lieu entre Lundi d'avant et dimanche (aujourd'hui étant lundi)
          if b.cancelled_at >= (Date.today - 1.week) && b.cancelled_at < Date.today
          @refunded_bookings << b
          end
        end
        # Vérifier que la date de création de la réservation a eu lieu entre Lundi d'avant et dimanche (aujourd'hui étant lundi)
        if b.created_at >= (Date.today - 1.week) && b.created_at < Date.today
          @new_bookings << b
        end
      end
      if @refunded_bookings.size > 0 || @new_bookings.size > 0
        UserMailer.with(user: p.user, new_bookings: @new_bookings, refunded_bookings: @refunded_bookings).partner_weekly_client_invoices.deliver_later
      end
    end
    reschedule_job
  end

  def reschedule_job
    self.class.set(wait_until: (Date.today + 7.days).noon).perform_later
  end
end
