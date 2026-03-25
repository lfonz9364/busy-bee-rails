require "test_helper"

class DeveloperTest < ActiveSupport::TestCase
  test "developer receives feedback via jobs" do
    client     = create_client
    developer  = create_developer

    # AND a job linking that client + developer
    job = create_job(client: client, developer: developer)

    # AND feedback written by the client on that job
    feedback = Feedback.create!(
      job: job,
      user: client.user,
      rating: 5,
      comment: "Great work",
      role: "client"
    )

    # WHEN we ask the developer for received feedback
    received = developer.received_feedbacks

    # THEN it includes that feedback
    assert_includes received, feedback
    assert_equal 1, received.count
    assert_equal "Great work", received.first.comment
  end

  test "average rating returns 0.0 when no feedbacks" do
    developer = create_developer

    assert_equal 0.0, developer.average_rating
    assert_equal 0, developer.reviews_count
  end

  test "average rating returns the average of received client feedbacks" do
    client_1 = create_client
    client_2 = create_client
    developer = create_developer

    job_1 = create_job(client: client_1, developer: developer)
    job_2 = create_job(client: client_2, developer: developer)

    Feedback.create!(
      job: job_1,
      user: client_1.user,
      rating: 3,
      comment: "Good enough",
      role: "client"
    )

    Feedback.create!(
      job: job_2,
      user: client_2.user,
      rating: 5,
      comment: "Excellent work",
      role: "client"
    )

    assert_equal 4.0, developer.average_rating
    assert_equal 2, developer.reviews_count
  end

  test "developer groups pending applications correctly" do
    client = create_client
    developer = create_developer
    other_developer = create_developer

    job_1 = create_job(client: client, developer: nil, status: "open")
    job_2 = create_job(client: client, developer: nil, status: "open")

    app_1 = JobApplication.create!(job: job_1, developer: developer, status: "pending", message: "Pending app")
    JobApplication.create!(job: job_2, developer: other_developer, status: "pending", message: "Other app")

    assert_includes developer.pending_job_applications, app_1
    assert_equal 1, developer.pending_job_applications.count
  end

  test "developer groups declined and auto declined applications correctly" do
    client = create_client
    developer = create_developer

    job_1 = create_job(client: client, developer: nil, status: "open")
    job_2 = create_job(client: client, developer: nil, status: "open")

    declined = JobApplication.create!(job: job_1, developer: developer, status: "declined", message: "Declined")
    auto_declined = JobApplication.create!(job: job_2, developer: developer, status: "auto_declined", message: "Auto declined")

    declined_apps = developer.declined_job_applications

    assert_includes declined_apps, declined
    assert_includes declined_apps, auto_declined
    assert_equal 2, declined_apps.count
  end

  test "developer groups in progress jobs correctly" do
    client = create_client
    developer = create_developer

    in_progress_job = create_job(client: client, developer: developer, status: "in_progress")
    create_job(client: client, developer: developer, status: "completed")

    assert_includes developer.in_progress_jobs, in_progress_job
    assert_equal 1, developer.in_progress_jobs.count
  end

  test "developer groups completed jobs correctly" do
    client = create_client
    developer = create_developer

    completed_job = create_job(client: client, developer: developer, status: "completed")
    create_job(client: client, developer: developer, status: "in_progress")

    assert_includes developer.completed_jobs, completed_job
    assert_equal 1, developer.completed_jobs.count
  end
end