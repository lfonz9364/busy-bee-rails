require "test_helper"

class DeveloperTest < ActiveSupport::TestCase
  test "developer receives feedback via jobs" do
    client     = create_client
    developer  = create_developer

    # AND a job linking that client + developer
    job = Job.create!(
      client: client,
      developer: developer,
      title: "Test Job",
      description: "Do something",
      reward: 1000,
      status: "open",
      deadline: 1.week.from_now
    )

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
end