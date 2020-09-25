require 'test_helper'

class BookingMailerTest < ActionMailer::TestCase
  test "new_booking_btob" do
    mail = BookingMailer.new_booking_btob
    assert_equal "New booking btob", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "new_booking_btoc" do
    mail = BookingMailer.new_booking_btoc
    assert_equal "New booking btoc", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "cancel_booking_btob" do
    mail = BookingMailer.cancel_booking_btob
    assert_equal "Cancel booking btob", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "cancel_booking_btoc" do
    mail = BookingMailer.cancel_booking_btoc
    assert_equal "Cancel booking btoc", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
