class GiftcardMailer < ApplicationMailer
  def confirmation
    @giftcard = params[:giftcard]
    attachments["carte-cadeau-#{@giftcard.code}.pdf"] = WickedPdf.new.pdf_from_string(
    render_to_string(template: 'giftcards/confirmation_achat.pdf.erb')
  )
    mail(
      to:       @giftcard.user.email,
      subject:  "Confirmation de votre commande de carte cadeau !",
      track_opens: 'true',
      message_stream: 'outbound')
  end
end
