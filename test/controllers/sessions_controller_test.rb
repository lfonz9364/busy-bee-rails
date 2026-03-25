require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login page" do
    get login_url
    assert_response :success
  end

  test "should log in with valid credentials using single redirect chain" do
    user = create_user

    post login_url, params: { email: user.email, password: "password123" }
    
    assert_redirected_to user_url(user)

    follow_redirect!

    assert_response :success
    assert_not response.redirect?

    assert_select "div.notice", text: "Logged in!"
  end

  test "login redirects client to my posted jobs" do
    client = create_client

    post login_url, params: {
      email: client.user.email,
      password: "password123"
    }

    assert_redirected_to my_posted_jobs_url

    follow_redirect!

    assert_response :success
    assert_not response.redirect?

    assert_select "div.notice", text: "Logged in!"
  end

  test "login redirects developer to my applications" do
    developer = create_developer

    post login_url, params: {
      email: developer.user.email,
      password: "password123"
    }

    assert_redirected_to my_applications_url

    follow_redirect!

    assert_response :success
    assert_not response.redirect?

    assert_select "div.notice", text: "Logged in!"
  end

  test "login redirects admin to users list" do
    admin = create_admin

    post login_url, params: {
      email: admin.email,
      password: "password123"
    }

    assert_redirected_to users_url

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
