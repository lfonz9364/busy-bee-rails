require "test_helper"

class DeveloperControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    create_developer
    get developers_url

    assert_response :success
  end

  test "should show developer" do
    developer = create_developer
    get developer_url(developer)
    assert_response :success
  end
end