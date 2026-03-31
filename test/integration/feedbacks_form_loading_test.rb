require "test_helper"

class FeedbacksFormLoadingTest < ActionDispatch::IntegrationTest
  test "create feedback form renders loading text on submit button" do
    client = create_client
    developer = create_developer
    job = create_job(client:, developer:, status:"completed")

    sign_in_as(client)

    get job_path(job)

    get new_job_feedback_path(job)

    assert_response :success
    assert_select "input[type=submit][value='Create feedback'][data-loading-text='Creating feedback...']"
  end

  test "update feedback form renders loading text on submit button" do
    client = create_client
    developer = create_developer
    job = create_job(client:, developer:, status:"completed")

    feedback = create_feedback(
      job: job, 
      user: client.user, 
      rating: 4, 
      comment: "Great work!", 
      role:"client"
    )

    sign_in_as(client)

    get job_path(job)  

    get edit_feedback_path(feedback)

    assert_response :success
    assert_select "input[type=submit][value='Update feedback'][data-loading-text='Updating feedback...']"
  end
end