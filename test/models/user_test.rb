require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name:"Example User", email: "user@example.com")
  end
  test "should be valid" do
    assert @user.valid?
  end
  test "name should be present" do
    @user.name="  "
    assert_not @user.valid?
  end
  test "email should be present" do
    @user.email="  "
    assert_not @user.valid?
  end
  test "name should not be too long" do
    @user.name="a"*51
    assert_not @user.valid?
  end
  test "email should not be too long" do
    @user.name="a"*244+"@example.com"
    assert_not @user.valid?
  end
  test "email validation should accept valid email" do
    valid_address = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@org.com foo+bar@baz.com]
    valid_address.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end
  test "email validation should not accept invalid email" do
    valid_address = %w[user@example,com user_at_foo.org user.name@example.
    foo@bar_baz.com foo@bar+baz.com]
    valid_address.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should not be valid"
    end
  end
  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

end
