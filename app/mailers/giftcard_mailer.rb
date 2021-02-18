class GiftcardMailer < ApplicationMailer
  def confirmation
    @giftcard = params[:giftcard]
    attachments["carte-cadeau-jdm-#{@giftcard.code}.pdf"] = WickedPdf.new.pdf_from_string(
    render_to_string(template: 'giftcards/confirmation_achat.pdf.erb')
    )
    attachments["cgv-jdm-#{Date.today.strftime("%d-%m-%y")}.pdf"] = WickedPdf.new.pdf_from_string(
    render_to_string(template: 'pages/cgv.pdf.erb')
    )
    mail(
      to:       @giftcard.user.email,
      subject:  "Confirmation de votre commande de carte cadeau !",
      track_opens: 'true',
      message_stream: 'outbound')
  end
end
