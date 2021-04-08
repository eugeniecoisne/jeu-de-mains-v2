class ContactMailer < ApplicationMailer

  def internal_send_contact_message

    @contact = params[:contact]
    @email = params[:contact][:email]

    mail(from: 'contact@jeudemains.com',
      to: 'contact@jeudemains.com',
      subject: "jeudemains.com : nouveau message de #{@email}",
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def external_send_contact_message

    @contact = params[:contact]
    @email = params[:contact][:email]

    mail(from: 'contact@jeudemains.com',
      to: @email,
      subject: "Nous vous confirmons la bonne réception de votre message !",
      track_opens: 'true',
      message_stream: 'outbound')
  end

end
