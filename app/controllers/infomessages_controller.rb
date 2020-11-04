class InfomessagesController < ApplicationController
  def create
    @session = Session.find(params[:session_id])
    @infomessage = Infomessage.new(infomessage_params)
    @infomessage.session = @session
    authorize @infomessage
    if @infomessage.save
      mail = InfomessageMailer.with(infomessage: @infomessage).new_information
      mail.deliver_later
      redirect_back fallback_location: root_path
      flash[:notice] = "Votre e-mail a bien été envoyé aux participants, vous êtes en copie de cet e-mail."
    else
      redirect_back fallback_location: root_path
      flash[:alert] = "Votre e-mail n'a pas pu être remis. Vérifiez que le champ 'votre message' est bien rempli. Si le problème subsiste, contactez-nous."
    end
  end

  private

  def infomessage_params
    params.require(:infomessage).permit(:subject, :content)
  end
end
