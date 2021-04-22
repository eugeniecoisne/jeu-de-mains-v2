class PrivatisationMailer < ApplicationMailer

  def send_form_btob

    @privatisation = params[:privatisation]
    @client_email = params[:privatisation][:email]
    @workshop = params[:workshop]
    @partner_email = @workshop.place.user.email

    mail(from: 'contact@jeudemains.com',
      to: @partner_email,
      bcc: 'contact@jeudemains.com',
      subject: "Jeu de Mains : demande de privatisation de #{@client_email}",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def confirm_form_btoc

    @privatisation = params[:privatisation]
    @client_email = params[:privatisation][:email]
    @workshop = params[:workshop]

    mail(from: 'contact@jeudemains.com',
      to: @client_email,
      subject: "Nous avons bien reçu et transmis votre demande de privatisation !",
      track_opens: 'true',
      message_stream: 'outbound')
  end

end
