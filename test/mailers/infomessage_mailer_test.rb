require 'test_helper'

class InfomessageMailerTest < ActionMailer::TestCase
  test "new_information" do
    mail = InfomessageMailer.new_information
    assert_equal "New information", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
