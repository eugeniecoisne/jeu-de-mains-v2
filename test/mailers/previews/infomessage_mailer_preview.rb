# Preview all emails at http://localhost:3000/rails/mailers/infomessage_mailer
class InfomessageMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/infomessage_mailer/new_information
  def new_information
    InfomessageMailer.new_information
  end

end
