require "test_helper"

class JobApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "developer can apply to open job" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    sign_in_as(developer.user)

    assert_difference("JobApplication.count", 1) do
      post job_job_applications_url(job), params: {
        job_application: {
          message: "I am interested in this role."
        }
      }
    end

    assert_redirected_to job_url(job)
    assert_equal developer, JobApplication.last.developer
    assert_equal "pending", JobApplication.last.status
  end

  test "developer cannot apply twice to the same job" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    JobApplication.create!(
      job: job,
      developer: developer,
      message: "First application"
    )

    sign_in_as(developer.user)

    assert_no_difference("JobApplication.count") do
      post job_job_applications_url(job), params: {
        job_application: {
          message: "Second application"
        }
      }
    end

    assert_redirected_to job_url(job)
  end

  test "client can accept application" do
    client = create_client
    developer = create_developer
    other_developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    accepted_application = JobApplication.create!(
      job: job,
      developer: developer,
      message: "Pick me"
    )

    other_application = JobApplication.create!(
      job: job,
      developer: other_developer,
      message: "Pick me instead"
    )

    sign_in_as(client.user)

    patch accept_job_application_url(accepted_application)

    assert_redirected_to job_url(job)
    assert_equal "accepted", accepted_application.reload.status
    assert_equal "declined", other_application.reload.status
    assert_equal developer, job.reload.developer
    assert_equal "in_progress", job.status
  end

  test "client can decline application" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    application = JobApplication.create!(
      job: job,
      developer: developer,
      message: "Please review"
    )

    sign_in_as(client.user)

    patch decline_job_application_url(application)

    assert_redirected_to job_url(job)
    assert_equal "declined", application.reload.status
  end

  test "non owner client cannot review application" do
    client = create_client
    other_client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    application = JobApplication.create!(
      job: job,
      developer: developer,
      message: "Please review"
    )

    sign_in_as(other_client.user)

    patch accept_job_application_url(application)

    assert_redirected_to root_url
    assert_equal "pending", application.reload.status
  end
end