require 'test_helper'

class SessionMailerTest < ActionMailer::TestCase
  test "cancel_and_giveback" do
    mail = SessionMailer.cancel_and_giveback
    assert_equal "Cancel and giveback", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
