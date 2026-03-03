require "test_helper"

class ClientControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    create_client
    get clients_url
    
    assert_response :success
  end

  test "should show client" do
    client = create_client
    get client_url(client)
    
    assert_response :success
  end
end