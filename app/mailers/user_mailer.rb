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

end
