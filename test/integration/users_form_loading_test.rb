require "test_helper"

class UsersFormLoadingTest < ActionDispatch::IntegrationTest
  test "signup form renders loading text on submit button" do
    get signup_path

    assert_response :success
    assert_select "input[type=submit][value='Create account'][data-loading-text='Creating account...']"
  end

  test "update profile form renders loading text on submit button" do
    client = create_client

    sign_in_as(client)

    get edit_user_path(client.user)

    assert_response :success
    assert_select "input[type=submit][value='Update profile'][data-loading-text='Updating profile...']"
  end
end