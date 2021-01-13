# Preview all emails at http://localhost:3000/rails/mailers/workshop_mailer
class WorkshopMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/workshop_mailer/create_confirmation
  def create_confirmation
    WorkshopMailer.create_confirmation
  end

  def invite_partner
    WorkshopMailer.invite_partner
  end

end
