require "test_helper"

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    ActionMailer::Base.deliveries.clear
    clear_enqueued_jobs
    clear_performed_jobs
  end

  test "can request password reset for existing user" do
    user = create_user(email: "reset@example.com")

    assert_equal "reset@example.com", user.email
    assert User.find_by(email: "reset@example.com").present?

    assert_enqueued_jobs 1 do
      post forgot_password_url, params: { email: "reset@example.com" }
    end
    # assert_emails 1 do
    #   perform_enqueued_jobs do
    #     post forgot_password_url, params: { email: user.email }
    #   end
    # end

    perform_enqueued_jobs

    assert_equal 1, ActionMailer::Base.deliveries.count
    # assert_redirected_to login_url
    # assert user.reload.reset_password_token.present?
  end

  test "forgot password does not reveal whether email exists" do
    post forgot_password_url, params: { email: "missing@example.com" }

    assert_redirected_to login_url
  end

  test "can open reset password page with valid token" do
    user = create_user
    user.generate_password_reset_token!

    get reset_password_url(user.reset_password_token)

    assert_response :success
  end

  test "cannot open reset password page with expired token" do
    user = create_user(
      reset_password_token: "expiredtoken",
      reset_password_sent_at: 3.hours.ago
    )

    get reset_password_url(user.reset_password_token)

    assert_redirected_to forgot_password_url
  end

  test "can reset password with valid token" do
    user = create_user
    user.generate_password_reset_token!

    patch reset_password_url(user.reset_password_token), params: {
      user: {
        password: "newpassword123",
        password_confirmation: "newpassword123"
      }
    }

    assert_redirected_to login_url
    assert user.reload.authenticate("newpassword123")
    assert_nil user.reset_password_token
  end
end