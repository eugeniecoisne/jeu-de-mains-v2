require 'test_helper'

class PlaceMailerTest < ActionMailer::TestCase
  test "create_confirmation" do
    mail = PlaceMailer.create_confirmation
    assert_equal "Create confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
