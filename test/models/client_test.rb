# test/models/client_test.rb
require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "client authored_feedbacks returns feedback they wrote" do

    client     = create_client
    developer  = create_developer

    # job linking them
    job = Job.create!(
      client: client,
      developer: developer,
      title: "Another Job",
      description: "Do more things",
      reward: 2000,
      status: "open",
      deadline: 2.weeks.from_now
    )

    # feedback written by client_user
    feedback = Feedback.create!(
      job: job,
      user: client.user,
      rating: 4,
      comment: "Good job",
      role: "client"
    )

    # WHEN we ask the client for feedback they've authored
    authored = client.authored_feedbacks

    assert_includes authored, feedback
    assert_equal 1, authored.count
    assert_equal "Good job", authored.first.comment
  end

  test "client groups open jobs correctly" do
    client = create_client
    other_client = create_client

    open_job = create_job(client: client, developer: nil, status: "open")
    create_job(client: client, developer: nil, status: "completed")
    create_job(client: other_client, developer: nil, status: "open")

    assert_includes client.open_jobs, open_job
    assert_equal 1, client.open_jobs.count
  end

  test "client groups in progress jobs correctly" do
    client = create_client
    developer = create_developer

    in_progress_job = create_job(client: client, developer: developer, status: "in_progress")
    create_job(client: client, developer: developer, status: "completed")

    assert_includes client.in_progress_jobs, in_progress_job
    assert_equal 1, client.in_progress_jobs.count
  end

  test "client groups completed jobs correctly" do
    client = create_client
    developer = create_developer

    completed_job = create_job(client: client, developer: developer, status: "completed")
    create_job(client: client, developer: developer, status: "cancelled")

    assert_includes client.completed_jobs, completed_job
    assert_equal 1, client.completed_jobs.count
  end

  test "client groups cancelled jobs correctly" do
    client = create_client
    developer = create_developer

    cancelled_job = create_job(client: client, developer: developer, status: "cancelled")
    create_job(client: client, developer: developer, status: "open")

    assert_includes client.cancelled_jobs, cancelled_job
    assert_equal 1, client.cancelled_jobs.count
  end
end