# Preview all emails at http://localhost:3000/rails/mailers/session_mailer
class SessionMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/session_mailer/cancel_and_giveback
  def cancel_and_giveback
    SessionMailer.cancel_and_giveback
  end

end
