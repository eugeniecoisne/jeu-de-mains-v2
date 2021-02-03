class PartnerMailer < ApplicationMailer

  def internal_send_subscription_form

    @partner = params[:partner]

    mail(from: 'contact@jeudemains.com',
      to: 'contact@jeudemains.com',
      subject: "Partenaire : Demande d'inscription de #{@partner[:company]}",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def external_send_subscription_form

    @partner = params[:partner]
    @email = params[:partner][:email]

    mail(from: 'contact@jeudemains.com',
      to: @email,
      subject: "Votre demande d'inscription partenaire a bien été envoyée !",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def send_welcome_partner_email

    @profile = params[:profile]

    mail(from: 'contact@jeudemains.com',
      to: @profile.user.email,
      subject: "Votre profil partenaire est créé, dernières étapes avant la mise en ligne !",
      track_opens: 'true',
      message_stream: 'outbound')
  end

end
