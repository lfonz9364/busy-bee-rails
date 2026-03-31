require "test_helper"

class SessionsFormLoadingTest < ActionDispatch::IntegrationTest
  test "login form renders loading text on submit button" do
    get login_path

    assert_response :success
    assert_select "input[type=submit][value='Login'][data-loading-text='Logging in...']"
  end
end