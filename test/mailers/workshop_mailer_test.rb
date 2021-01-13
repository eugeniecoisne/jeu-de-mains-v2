require 'test_helper'

class WorkshopMailerTest < ActionMailer::TestCase
  test "create_confirmation" do
    mail = WorkshopMailer.create_confirmation
    assert_equal "Create confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "invite_partner" do
    mail = WorkshopMailer.invite_partner
    assert_equal "Invite partner", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
