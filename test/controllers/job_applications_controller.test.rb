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

  test "developer application saves the submitted message" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    sign_in_as(developer.user)

    post job_job_applications_url(job), params: {
      job_application: {
        message: "I have 5 years of Rails experience."
      }
    }

    assert_redirected_to job_url(job)

    application = JobApplication.last
    assert_equal developer, application.developer
    assert_equal job, application.job
    assert_equal "I have 5 years of Rails experience.", application.message
  end

  test "developer application can be created with blank message" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    sign_in_as(developer.user)

    post job_job_applications_url(job), params: {
      job_application: {
        message: ""
      }
    }

    assert_redirected_to job_url(job)
    assert_equal "", JobApplication.last.message
  end

  test "developer can view their grouped applications page" do
    client = create_client
    developer = create_developer
    other_developer = create_developer

    pending_job = create_job(client: client, developer: nil, status: "open")
    declined_job = create_job(client: client, developer: nil, status: "open")
    in_progress_job = create_job(client: client, developer: developer, status: "in_progress")
    completed_job = create_job(client: client, developer: developer, status: "completed")

    JobApplication.create!(job: pending_job, developer: developer, status: "pending", message: "Pending message")
    JobApplication.create!(job: declined_job, developer: developer, status: "declined", message: "Declined message")
    JobApplication.create!(job: pending_job, developer: other_developer, status: "pending", message: "Other developer")

    sign_in_as(developer.user)

    get my_applications_url

    assert_response :success
    assert_match "Pending Applications", @response.body
    assert_match "In Progress Jobs", @response.body
    assert_match "Declined Applications", @response.body
    assert_match "Completed Jobs", @response.body

    assert_match pending_job.title, @response.body
    assert_match declined_job.title, @response.body
    assert_match in_progress_job.title, @response.body
    assert_match completed_job.title, @response.body
  end

  test "non developer cannot view grouped applications page" do
    client = create_client

    sign_in_as(client.user)

    get my_applications_url

    assert_redirected_to root_url
  end
end