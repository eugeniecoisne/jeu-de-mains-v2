# Preview all emails at http://localhost:3000/rails/mailers/booking_mailer
class BookingMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer/new_booking_btob
  def new_booking_btob
    BookingMailer.new_booking_btob
  end

  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer/new_booking_btoc
  def new_booking_btoc
    BookingMailer.new_booking_btoc
  end

  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer/cancel_booking_btob
  def cancel_booking_btob
    BookingMailer.cancel_booking_btob
  end

  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer/cancel_booking_btoc
  def cancel_booking_btoc
    BookingMailer.cancel_booking_btoc
  end

end
