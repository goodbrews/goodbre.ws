require "minitest_helper"

class UserMailerTest < ActionMailer::TestCase
  test 'must deliver a welcome message to new users' do
    user = Factory(:user)

    assert_equal 1, ActionMailer::Base.deliveries.size
    email = ActionMailer::Base.deliveries.last
    assert_equal [user.email], email.to
    assert_equal 'Welcome to goodbre.ws!', email.subject
    assert_match "<p>Hey there, #{user.username}!</p>", email.body.to_s
    assert_match 'Thank you for joining goodbre.ws!', email.body.to_s
  end

  test 'must send password reset emails to users upon request' do
    user = Factory.build(:user)
    user.send_password_reset

    assert_equal 1, ActionMailer::Base.deliveries.size
    email = ActionMailer::Base.deliveries.last
    assert_equal [user.email], email.to
    assert_equal 'goodbre.ws - Password Reset', email.subject
    assert_match 'Hey there! Click the URL below to reset your password.', email.body.to_s
    assert_match edit_password_reset_url(user.password_reset_token), email.body.to_s
  end
end
