class BookingMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.new_booking_btob.subject
  #
  def new_booking_btob
    @booking = params[:booking]
    @organizer = @booking.session.workshop.place.user

    if @booking.session.workshop.animators.where(db_status: true).present?
      @animator = @booking.session.workshop.animators.where(db_status: true).last.user

      mail(
        to:       "#{@organizer.email}, #{@animator.email}",
        subject:  "Vous avez une réservation pour l'atelier #{@booking.session.workshop.title} !",
        track_opens: 'true',
        message_stream: 'outbound')
    else
      mail(
        to:       "#{@organizer.email}",
        subject:  "Vous avez une réservation pour l'atelier #{@booking.session.workshop.title} !",
        track_opens: 'true',
        message_stream: 'outbound')
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.new_booking_btoc.subject
  #
  def new_booking_btoc
    @booking = params[:booking]

    mail(
      to:       @booking.user.email,
      subject:  "Confirmation de votre réservation pour l'atelier #{@booking.session.workshop.title} !",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.cancel_booking_btob.subject
  #
  def cancel_booking_btob
    @booking = params[:booking]
    @organizer = @booking.session.workshop.place.user

    if @booking.session.workshop.animators.where(db_status: true).present?
      @animator = @booking.session.workshop.animators.where(db_status: true).last.user

      mail(
        to:       "#{@organizer.email}, #{@animator.email}",
        subject:  "Vous avez une annulation pour l'atelier #{@booking.session.workshop.title}",
        track_opens: 'true',
        message_stream: 'outbound')
    else
      mail(
        to:       "#{@organizer.email}",
        subject:  "Vous avez une annulation pour l'atelier #{@booking.session.workshop.title}",
        track_opens: 'true',
        message_stream: 'outbound')
    end
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
    )
  end
end
