require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login page" do
    get login_url
    assert_response :success
  end

  test "should log in with valid credentials using single redirect chain" do
    user = create_user

    post login_url, params: { email: user.email, password: "password123" }
    
    assert_redirected_to jobs_url

    follow_redirect!

    assert_response :success
    assert_not response.redirect?

    assert_select "div.notice", text: "Logged in!"
  end

  test "should not log in with invalid credentials" do
    post login_url, params: { email: "invalid@example.com", password: "wrongpassword" }
    assert_response :unprocessable_entity
    assert_select "div.alert", text: "Email or password is invalid"
  end

  test "should log out" do
    user = create_user
    sign_in_as(user)
    delete logout_url
    assert_redirected_to root_url
    follow_redirect!
    assert_select "div.notice", text: "Logged out!"
  end
end
