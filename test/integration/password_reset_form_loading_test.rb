require "test_helper"

class PasswordResetFormLoadingTest < ActionDispatch::IntegrationTest
  test "password reset update showed loading on submit" do
    user = create_user
    user.generate_password_reset_token!

    get reset_password_url(user.reset_password_token)

    assert_response :success
    assert_select "input[type=submit][value='Reset password'][data-loading-text='Updating password...']"
  end
end