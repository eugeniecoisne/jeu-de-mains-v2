class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #

  def welcome
    @user = params[:user]
    if @user.created_at >= Date.today - 7
      mail(from: 'contact@jeudemains.com',
        to: @user.email,
        subject: 'Jeu de Mains vous souhaite la bienvenue !',
        track_opens: 'true',
        message_stream: 'outbound')

    end
  end

  def export_new_weekly_subscribers
    @users = params[:users]

    @csv = CSV.generate(headers: true) do |csv|
      csv << %w{email newsletter_agreement}
      @users.each do |u|
        csv << [u.email, u.newsletter_agreement]
      end
    end

    attachments["#{Date.today.strftime("%Y%m%d")}_jdm_nouveaux_abonnes.csv"] = { mime_type: 'text/csv', content: @csv }

    mail(
      to:       "contact@jeudemains.com",
      subject:  "Export nouveaux abonnés de la semaine",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def partner_monthly_report
    @user = params[:user]
    @workshops = Workshop.all.select { |w| w.place.user == @user || (w.animators.where(db_status: true).last.user == @user if w.animators.where(db_status: true).present?) }

    @start_last_month = (DateTime.now.to_date - 1.month).beginning_of_month
    @end_last_month = (DateTime.now.to_date - 1.month).end_of_month
    @success_organized_and_animated_bookings = Booking.all.where(db_status: true).select { |b| b.status == "paid" && b.created_at >= @start_last_month && b.created_at <= @end_last_month}.select { |b| b.session.workshop.place.user == @user || (b.session.workshop.animators.where(db_status: true).last.user == @user if b.session.workshop.animators.where(db_status: true).present?) }
    @refund_organized_and_animated_bookings = Booking.all.where(db_status: true).select { |b| b.status == "refunded" && b.cancelled_at >= @start_last_month && b.cancelled_at <= @end_last_month}.select { |b| b.session.workshop.place.user == @user || (b.session.workshop.animators.where(db_status: true).last.user == @user if b.session.workshop.animators.where(db_status: true).present?) }

    @success_organized_bookings = Booking.all.where(db_status: true).select { |b| b.status == "paid" && b.created_at >= @start_last_month && b.created_at <= @end_last_month}.select { |b| b.session.workshop.place.user == @user }
    @refund_organized_bookings = Booking.all.where(db_status: true).select { |b| b.status == "refunded" && b.cancelled_at >= @start_last_month && b.cancelled_at <= @end_last_month}.select { |b| b.session.workshop.place.user == @user }

    @reviews = @user.profile.reviews.select { |r| r.created_at >= @start_last_month && r.created_at <= @end_last_month}

    mail(from: 'contact@jeudemains.com',
      to: @user.email,
      bcc: 'eugenie@jeudemains.com',
      subject: 'Votre bilan mensuel sur Jeu de Mains',
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def partner_weekly_client_invoices
    @user = params[:user]
    @new_bookings = params[:new_bookings]
    @refunded_bookings = params[:refunded_bookings]
    @partner = @user.profile

    @new_bookings.each do |b|
      @booking = b
      attachments["facture-F#{@partner.id}-#{@partner.invoice_number_for(@booking.id)}.pdf"] = WickedPdf.new.pdf_from_string(
      render_to_string(template: 'bookings/payment_success.pdf.erb', locals: {partner: @partner, booking: @booking})
      )
    end
    @refunded_bookings.each do |b|
      @booking = b
      attachments["avoir-A#{@partner.id}-#{@partner.refund_invoice_number_for(@booking.id)}.pdf"] = WickedPdf.new.pdf_from_string(
      render_to_string(template: 'bookings/refund_invoice.pdf.erb', locals: {partner: @partner, booking: @booking})
      )
    end

    mail(from: 'contact@jeudemains.com',
      to: @user.email,
      bcc: 'eugenie@jeudemains.com',
      subject: "Vos factures clients du #{l((Date.today - 7.days), format: '%A %d %b %Y')} au #{l((Date.today - 1.day), format: '%A %d %b %Y')}",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def partner_monthly_facturation
    @user = params[:user]
    @profile = @user.profile
    @year = (Date.today - 10.days).strftime("%Y")
    @month = (Date.today - 10.days).strftime("%m")
    @end = (Date.today - 10.days).end_of_month.strftime("%d")
    # facture de commission
    # relevé des transactions clients
    @transaction_bookings = []
    Booking.all.where(db_status: true).select { |b| b.status == "paid" || b.status == "refunded"}.select { |b| b.session.workshop.place.user.profile == @profile }.each do |b|
      if b.status == "refunded"
        @b_refund = {
          booking: b,
          date: b.cancelled_at.to_date,
          label: "Remboursement - base #{(b.refund_rate * 100).round}%",
          workshop: b.session.workshop,
          session: b.session,
          booking_number: "#{b.created_at.strftime("%Y%m")}#{b.id}",
          amount: b.amount,
          fee_rate: b.fee,
          tva_applicable: b.tva_applicable,
          refund_rate: b.refund_rate,
          status: "refunded"
        }
        @transaction_bookings << @b_refund
      end
      @b_success = {
        booking: b,
        date: b.created_at.to_date,
        label: "Paiement reçu",
        workshop: b.session.workshop,
        session: b.session,
        booking_number: "#{b.created_at.strftime("%Y%m")}#{b.id}",
        amount: b.amount,
        fee_rate: b.fee,
        tva_applicable: b.tva_applicable,
        status: "success"
      }
      @transaction_bookings << @b_success
    end

    if @transaction_bookings.size > 0

      attachments["releve-facturation-clients-#{@profile.accountant_company.parameterize}-de-#{l((Date.today - 10.days), format: "%B-%Y")}"] = WickedPdf.new.pdf_from_string(
      render_to_string(template: 'profiles/transactions.pdf.erb', locals: {profile: @profile, transaction_bookings: @transaction_bookings, month: @month, year: @year, end: @end})
      )

      @commission_bookings = @transaction_bookings
      @fee_invoice = FeeInvoice.all.where(profile_id: @profile.id).select { |f| f.start_date == Date.new(@year.to_i, @month.to_i, 1) }.last

      attachments["facture-P-#{Array.new((6-(@fee_invoice.id.to_s.size)), "0").join('')}#{@fee_invoice.id}"] = WickedPdf.new.pdf_from_string(
      render_to_string(template: 'profiles/releve_de_commissions.pdf.erb', locals: {profile: @profile, commission_bookings: @commission_bookings, month: @month, year: @year, end: @end})
      )

      mail(from: 'contact@jeudemains.com',
        to: @user.email,
        bcc: 'eugenie@jeudemains.com',
        subject: "Votre facture de commissions et votre relevé de facturation clients du mois de #{l((Date.today - 10.days), format: "%B %Y")}",
        track_opens: 'true',
        message_stream: 'outbound')

    end


  end
end
