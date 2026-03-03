require "test_helper"

class ClientControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    create_client
    get clients_url
    
    assert_response :success
  end

  test "should show client with name" do
    client = create_client
    get client_url(client)
    
    assert_response :success
    assert_match client.name, @response.body
  end

  test "should show given feedbacks" do
    client = create_client
    developer = create_developer

    job = create_job(client: client, developer: developer)

    feedback = create_feedback(
      job: job, 
      user: client.user, 
      rating: 5, 
      comment: "Excellent work!", 
      role:"client"
    )

    get client_url(client)

    assert_response :success
    assert_match feedback.comment, @response.body
    assert_match feedback.rating.to_s, @response.body
    assert_match feedback.job.title, @response.body
  end
end