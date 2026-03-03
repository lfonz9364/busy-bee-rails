require "test_helper"

class DeveloperControllerTest < ActionDispatch::IntegrationTest
  test "should show developer with name" do
    developer = create_developer

    get developer_url(developer)
    
    assert_response :success
    assert_match developer.name, @response.body
  end

  test "should show received feedbacks" do
    developer = create_developer
    client = create_client

    job = create_job(client: client, developer: developer)

    feedback = create_feedback(
      job: job, 
      user: client.user, 
      rating: 4, 
      comment: "Great work!", 
      role:"client"
    )

    get developer_url(developer)

    assert_response :success
    assert_match feedback.comment, @response.body
    assert_match feedback.rating.to_s, @response.body
  end
end