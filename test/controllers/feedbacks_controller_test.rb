require "test_helper"

class FeedbacksControllerTest < ActionDispatch::IntegrationTest
  test "client can access new feedback form only when job is completed" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: developer, status: "completed")

    sign_in_as(client.user)

    get new_job_feedback_url(job)

    assert_response :success
  end

  test "client cannot access new feedback form when job is not completed" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: developer, status: "in_progress")

    sign_in_as(client.user)

    get new_job_feedback_url(job)

    assert_redirected_to job_url(job)
  end

  test "client can create feedback only when job is completed" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: developer, status: "completed")

    sign_in_as(client.user)

    assert_difference("Feedback.count", 1) do
      post job_feedbacks_url(job), params: {
        feedback: {
          rating: 5,
          comment: "Great work"
        }
      }
    end

    assert_redirected_to job_url(job)
  end

  test "client cannot create feedback when job is not completed" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: developer, status: "in_progress")

    sign_in_as(client.user)

    assert_no_difference("Feedback.count") do
      post job_feedbacks_url(job), params: {
        feedback: {
          rating: 5,
          comment: "Great work"
        }
      }
    end

    assert_redirected_to job_url(job)
  end
end