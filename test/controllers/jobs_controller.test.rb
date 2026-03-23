require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    create_job
    get jobs_url
    
    assert_response :success
  end

  test "should show job with title" do
    job = create_job

    get job_url(job)
    
    assert_response :success
    assert_match job.title, @response.body
  end

  test "should show job details" do
    job = create_job

    get job_url(job)

    assert_response :success
    assert_match job.description, @response.body
    assert_match job.status, @response.body
  end

  test "client owner can mark in progress job as completed" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: developer, status: "in_progress")

    sign_in_as(client.user)

    patch complete_job_url(job)

    assert_redirected_to job_url(job)
    assert_equal "completed", job.reload.status
  end

  test "non owner client cannot mark job as completed" do
    client = create_client
    other_client = create_client
    developer = create_developer
    job = create_job(client: client, developer: developer, status: "in_progress")

    sign_in_as(other_client.user)

    patch complete_job_url(job)

    assert_redirected_to job_url(job)
    assert_equal "in_progress", job.reload.status
  end

  test "job show displays edit feedback when client feedback already exists" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: developer, status: "completed")

    feedback = Feedback.create!(
      job: job,
      user: client.user,
      rating: 5,
      comment: "Great work",
      role: "client"
    )

    sign_in_as(client.user)

    get job_url(job)

    assert_response :success
    assert_select "a[href='#{edit_feedback_path(feedback)}']", text: "Edit feedback"
  end

  test "job show displays write feedback when client feedback does not exist" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: developer, status: "completed")

    sign_in_as(client.user)

    get job_url(job)

    assert_response :success
    assert_select "a[href='#{new_job_feedback_path(job)}']", text: "Write feedback"
  end

  test "client can view my posted jobs page" do
    client = create_client
    developer = create_developer

    open_job = create_job(client: client, developer: nil, status: "open")
    in_progress_job = create_job(client: client, developer: developer, status: "in_progress")
    completed_job = create_job(client: client, developer: developer, status: "completed")
    cancelled_job = create_job(client: client, developer: nil, status: "cancelled")

    sign_in_as(client.user)

    get my_posted_jobs_url

    assert_response :success
    assert_match "My Posted Jobs", @response.body
    assert_match open_job.title, @response.body
    assert_match in_progress_job.title, @response.body
    assert_match completed_job.title, @response.body
    assert_match cancelled_job.title, @response.body
  end

  test "non client cannot view my posted jobs page" do
    developer = create_developer

    sign_in_as(developer.user)

    get my_posted_jobs_url

    assert_redirected_to root_url
  end
end