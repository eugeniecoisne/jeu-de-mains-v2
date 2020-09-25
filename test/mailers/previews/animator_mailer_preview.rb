# Preview all emails at http://localhost:3000/rails/mailers/animator_mailer
class AnimatorMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/animator_mailer/new_animator
  def new_animator
    AnimatorMailer.new_animator
  end

end
