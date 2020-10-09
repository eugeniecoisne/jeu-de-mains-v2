class AnimatorMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.animator_mailer.new_animator.subject
  #
  def new_animator
    @animator = params[:animator]

    mail(
      to:       @animator.user.email,
      subject:  "Vous avez été nommé animateur d'un atelier chez #{@animator.workshop.place.name} !"
      track_opens: 'true',
      message_stream: 'outbound')
  end
end
