require "minitest_helper"

class UserTest < ActiveSupport::TestCase
  context 'during creation' do
    test 'must have an email address' do
      user = Factory.build(:user, email: nil)
      refute user.valid?
      assert_includes user.errors[:email], "can't be blank"
    end

    test 'must have an email address with an @ symbol' do
      user = Factory.build(:user, email: 'invalid')
      refute user.valid?
      assert_includes user.errors[:email], 'is invalid'
    end

    test 'must not use the same email address as an existing user' do
      user = Factory.create(:user)
      new_user = Factory.build(:user, email: user.email)
      refute new_user.valid?
      assert_includes new_user.errors[:email], 'is already in use'
    end

    test 'must have a password longer than short' do
      user = Factory.build(:user, password: 'short', password_confirmation: 'short')
      refute user.valid?
      assert_includes user.errors[:password], 'must be longer than 6 characters'
    end

    test 'must confirm any password changes' do
      user = Factory.build(:user)
      user.password = 'changed'
      refute user.valid?
      assert_includes user.errors[:password_confirmation], "doesn't match Password"
    end

    test 'must have an alphanumeric username (with possible underscores)' do
      user = Factory.build(:user, username: 'im_v4l1d')
      assert user.valid?

      user.username = 'inv@lid!'
      refute user.valid?
      assert_includes user.errors[:username], 'can only contain letters, numbers, and underscores'
    end

    test 'must have a username less than 20 characters' do
      user = Factory.build(:user, username: 'a')
      assert user.valid?

      user.username = 'holyfuckingshitlookathowlongiam'
      refute user.valid?
      assert_includes user.errors[:username], 'is too long (maximum is 20 characters)'
    end

    test 'must not use the same username as an existing user' do
      user = Factory.create(:user)
      new_user = Factory.build(:user, username: user.username)
      refute new_user.valid?
      assert_includes new_user.errors[:username], 'has already been taken'
    end

    test 'must deliver a welcoming email' do
      # TODO
    end
  end
end
