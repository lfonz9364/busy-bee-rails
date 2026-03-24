require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      address: "123 Test St",
      suburb: "Testville",
      state: "VIC",
      postcode: "1234",
      country: "Testland",
      contact_person: "Test Contact",
      abn: "123456789",
      password: "password",
      role: 'client',
      password_confirmation: "password"
    )
    assert user.valid?
  end

  test "invalid without required fields" do
    user = User.new
    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
    assert_includes user.errors[:email], "can't be blank"
    assert_includes user.errors[:address], "can't be blank"
    assert_includes user.errors[:suburb], "can't be blank"
    assert_includes user.errors[:postcode], "can't be blank"
    assert_includes user.errors[:country], "can't be blank"
    assert_includes user.errors[:contact_person], "can't be blank"
    assert_includes user.errors[:abn], "can't be blank"
    assert_includes user.errors[:role], "is not included in the list"
  end

  test "email must be unique" do
    create_user(
      name: "Existing User",
      email: "test@example.com",
      address: "123 Test St",
      suburb: "Testville",
      state: "VIC",
      postcode: "1234",
      country: "Testland",
      contact_person: "Test Contact",
      abn: "123456789",
      password: "password",
      password_confirmation: "password"
    )
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      address: "456 Test Ave",
      suburb: "Testville",
      state: "VIC",
      postcode: "1245",
      country: "Testland",
      contact_person: "Test Contact",
      abn: "987654321",
      password: "password",
      role:"developer",
      password_confirmation: "password"
    )
    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "generate_password_reset_token! sets token and timestamp" do
    user = create_user

    user.generate_password_reset_token!

    assert user.reload.reset_password_token.present?
    assert user.reset_password_sent_at.present?
  end

  test "password_reset_expired? returns true when token is older than 2 hours" do
    user = create_user(
      reset_password_token: "token123",
      reset_password_sent_at: 3.hours.ago
    )

    assert user.password_reset_expired?
  end

  test "password_reset_expired? returns false when token is recent" do
    user = create_user(
      reset_password_token: "token123",
      reset_password_sent_at: 30.minutes.ago
    )

    assert_not user.password_reset_expired?
  end
end