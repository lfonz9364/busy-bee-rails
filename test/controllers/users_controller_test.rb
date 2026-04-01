require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "redirects index when not logged in" do
    get users_url

    assert_redirected_to login_path
  end

  test "redirects index when logged in as non-admin" do
    user = create_user(admin: false)
    sign_in_as(user)

    get users_url

    assert_redirected_to root_path
  end

  test "allows index when logged in as admin" do
    admin = create_admin

    sign_in_as(admin)

    get users_url

    assert_response :success
  end

  test "redirects show when not logged in" do
    user = create_user

    get user_url(user)

    assert_redirected_to login_path
  end

  test "allows show for self" do
    user = create_user(admin: false)
    sign_in_as(user)

    get user_url(user)

    assert_response :success
  end

  test "redirects show for another non-admin user" do
    user = create_user(admin: false)
    other_user = create_user(admin: false)

    sign_in_as(user)

    get user_url(other_user)

    assert_redirected_to root_path
  end

  test "allows show for admin viewing another user" do
    admin = create_admin
    user = create_user

    sign_in_as(admin)

    get user_url(user)

    assert_response :success
  end

  test "admin can make another user admin" do
    admin = create_user(admin: true)
    user = create_user(admin: false)

    sign_in_as(admin)

    patch make_admin_user_url(user)

    assert_redirected_to users_path
    assert user.reload.admin?
  end

  test "non admin cannot make another user admin" do
    user = create_user(admin: false)
    other_user = create_user(admin: false)

    sign_in_as(user)

    patch make_admin_user_url(other_user)

    assert_redirected_to root_path
    assert_not other_user.reload.admin?
  end

  test "admin archives user with completed jobs" do
    admin = create_admin
    client = create_client
    developer = create_developer
    target = developer.user
    create_job(client:, developer:, status: "completed")

    sign_in_as(admin)

    delete user_path(target)

    assert_redirected_to users_path
    target.reload
    assert_not target.active?
    assert_not_nil target.deleted_at
  end
end