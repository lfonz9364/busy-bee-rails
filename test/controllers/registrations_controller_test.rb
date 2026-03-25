require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "signup as client creates client record" do
    email = "client@example.com"

    assert_difference("User.count", 1) do
      assert_difference("Client.count", 1) do
        assert_no_difference("Developer.count") do
          post signup_url, params: {
            user: {
              name: "Client User",
              email: email,
              password: "password123",
              password_confirmation: "password123",
              address: "123 Test St",
              suburb: "Testville",
              state: "VIC",
              postcode: "1234",
              country: "Testland",
              contact_person: "Test Contact",
              abn: "12345678901",
              role: "client",
              skillset: "should be ignored"
            }
          }
        end
      end
    end

    user = User.find_by!(email: email)
    assert_equal "client", user.role
    assert user.client.present?
    assert_nil user.developer
    assert_redirected_to root_url
  end

  test "signup as developer creates developer record" do
    email = "developer@example.com"

    assert_difference("User.count", 1) do
      assert_difference("Developer.count", 1) do
        post signup_url, params: {
          user: {
            name: "Developer User",
            email: email,
            password: "password123",
            password_confirmation: "password123",
            address: "123 Test St",
            suburb: "Testville",
            state: "VIC",
            postcode: "1234",
            country: "Testland",
            contact_person: "Test Contact",
            abn: "12345678901",
            skillset: "ruby",
            role: "developer"
          }
        }
      end
    end

    user = User.find_by!(email: email)
    assert_equal "developer", user.role
    assert user.developer.present?
    assert_redirected_to root_url
  end

  test "signup fails without user params" do
    assert_no_difference("User.count") do
      post signup_url, params: { name: "Bad Request" }
    end

    assert_response :bad_request
  end

  test "signup fails with invalid password confirmation" do
    assert_no_difference("User.count") do
      post signup_url, params: {
        user: {
          name: "Test",
          email: "test@example.com",
          password: "password123",
          password_confirmation: "wrong",
          address: "123 Test St",
          suburb: "Testville",
          state: "VIC",
          postcode: "1234",
          country: "Testland",
          contact_person: "Test Contact",
          abn: "12345678901",
          role: "client"
        } }
    end

    assert_response :unprocessable_entity
  end
end