# Preview all emails at http://localhost:3000/rails/mailers/place_mailer
class PlaceMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/place_mailer/create_confirmation
  def create_confirmation
    PlaceMailer.create_confirmation
  end

end
