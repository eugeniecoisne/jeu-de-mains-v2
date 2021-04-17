class BookingMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.new_booking_btob.subject
  #
  def new_booking_btob
    @booking = params[:booking]
    @organizer = @booking.session.workshop.place.user

    mail(
      to:       @organizer.email,
      subject:  "Vous avez une réservation pour l'atelier #{@booking.session.workshop.title} !",
      track_opens: 'true',
      message_stream: 'outbound')
  end


  def new_booking_btob_animator
    @booking = params[:booking]
    @animator = @booking.session.workshop.animators.where(db_status: true).last.user

    mail(
      to:       @animator.email,
      subject:  "Vous avez une réservation pour l'atelier #{@booking.session.workshop.title} !",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def new_booking_btoc
    @booking = params[:booking]
    attachments["cgv-jdm-#{Date.today.strftime("%d-%m-%y")}.pdf"] = WickedPdf.new.pdf_from_string(
    render_to_string(template: 'pages/cgv.pdf.erb')
    )

    mail(
      to:       @booking.user.email,
      subject:  "Confirmation de votre réservation pour l'atelier #{@booking.session.workshop.title} !",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  # quand un organisateur annule la session complète
  def cancel_session_by_partner_btoc
    @booking = params[:booking]

    mail(
      to:       @booking.user.email,
      subject:  "Votre atelier a malheureusement été annulé - Report ou remboursement au choix",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def report_booking_btoc
    @booking = params[:booking]
    @old_session_id = params[:old_session_id]
    attachments["cgv-jdm-#{Date.today.strftime("%d-%m-%y")}.pdf"] = WickedPdf.new.pdf_from_string(
    render_to_string(template: 'pages/cgv.pdf.erb')
    )

    mail(
      to:       @booking.user.email,
      subject:  "Confirmation du report de votre réservation pour l'atelier #{@booking.session.workshop.title}",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def report_booking_btob
    @booking = params[:booking]
    @old_session_id = params[:old_session_id]
    @organizer = @booking.session.workshop.place.user

    if @booking.session.workshop.animators.where(db_status: true).present?
      @animator = @booking.session.workshop.animators.where(db_status: true).last.user.email

      mail(
        bcc: "#{@organizer.email}, #{@animator}",
        subject:  "#{@booking.user.first_name} a reporté sa réservation d'atelier au #{@booking.session.date.strftime("%d/%m/%y")}",
        track_opens: 'true',
        message_stream: 'outbound')
    else

      mail(
        to:       @organizer.email,
        subject:  "#{@booking.user.first_name} a reporté sa réservation d'atelier au #{@booking.session.date.strftime("%d/%m/%y")}",
        track_opens: 'true',
        message_stream: 'outbound')
    end
  end


  def cancel_booking_btob
    @booking = params[:booking]
    @organizer = @booking.session.workshop.place.user

    mail(
      to:       @organizer.email,
      subject:  "Vous avez une annulation pour l'atelier #{@booking.session.workshop.title}",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def cancel_booking_btob_animator
    @booking = params[:booking]
    @animator = @booking.session.workshop.animators.where(db_status: true).last.user

    mail(
      to:       @animator.email,
      subject:  "Vous avez une annulation pour l'atelier #{@booking.session.workshop.title}",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.cancel_booking_btoc.subject
  #
  def cancel_booking_btoc
    @booking = params[:booking]

    mail(
      to:       @booking.user.email,
      subject:  "Confirmation d'annulation de votre réservation",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def reminder_booking_btoc
    @booking = params[:booking]

    if @booking.db_status == true && @booking.status == "paid"
      mail(
        to:       @booking.user.email,
        subject:  "Rappel : Vous avez un atelier demain !",
        track_opens: 'true',
        message_stream: 'outbound')
    end
  end

  def ask_review_btoc
    @booking = params[:booking]

    if @booking.db_status == true && @booking.status == "paid" && @booking.user.db_status == true
      mail(
        to:       @booking.user.email,
        subject:  "Donnez-nous votre avis sur l'atelier d'hier",
        track_opens: 'true',
        message_stream: 'outbound')
    end
  end

  def kit_expedition_notification
    @booking = params[:booking]

    if @booking.db_status == true && @booking.status == "paid" && @booking.kit_expedition_status == "Expédiée"
      mail(
        to:       @booking.user.email,
        subject:  "Votre kit créatif a été expédié par #{@booking.session.workshop.place.user.profile.company} !",
        track_opens: 'true',
        message_stream: 'outbound')
    end
  end
end
