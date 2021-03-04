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
      subject: 'Votre bilan mensuel sur Jeu de Mains',
      track_opens: 'true',
      message_stream: 'outbound')
  end

end
