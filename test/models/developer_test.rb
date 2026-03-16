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
end