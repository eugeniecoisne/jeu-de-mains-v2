require 'test_helper'

class AnimatorMailerTest < ActionMailer::TestCase
  test "new_animator" do
    mail = AnimatorMailer.new_animator
    assert_equal "New animator", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
