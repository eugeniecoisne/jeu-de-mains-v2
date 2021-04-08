class EntrepriseMailer < ApplicationMailer

  def internal_entreprise_contact_message

    @entreprise = params[:entreprise]
    @email = params[:entreprise][:email]
    @company = params[:entreprise][:company]

    mail(from: 'contact@jeudemains.com',
      to: 'contact@jeudemains.com',
      subject: "jeudemains.com : prise de contact entreprise #{@company}",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def external_entreprise_contact_message

    @entreprise = params[:entreprise]
    @email = params[:entreprise][:email]

    mail(from: 'contact@jeudemains.com',
      to: @email,
      subject: "Nous vous remercions pour votre demande de devis !",
      track_opens: 'true',
      message_stream: 'outbound')
  end

end
