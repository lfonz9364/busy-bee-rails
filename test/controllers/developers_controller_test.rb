require "test_helper"

class DevelopersControllerTest < ActionDispatch::IntegrationTest
    test "should get index" do
    create_developer
    get developers_url
    
    assert_response :success
  end

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

  test "should show rounded stars rating" do
    developer = create_developer
    client1 = create_client
    client2 = create_client

    job1 = create_job(client: client1, developer: developer)
    job2 = create_job(client: client2, developer: developer)

    create_feedback(
      job: job1, 
      user: client1.user, 
      rating: 4, 
      comment: "Great work!", 
      role:"client"
    )

    create_feedback(
      job: job2, 
      user: client2.user, 
      rating: 5, 
      comment: "Excellent!", 
      role:"client"
    )

    get developer_url(developer)

    assert_response :success
    assert_match "★★★★☆", @response.body
  end
end