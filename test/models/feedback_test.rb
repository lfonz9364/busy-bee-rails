# test/models/feedback_test.rb
require "test_helper"

class FeedbackTest < ActiveSupport::TestCase
  test "developer and client helpers resolve correctly" do
    client     = create_client
    developer  = create_developer

    job = Job.create!(
      client: client,
      developer: developer,
      title: "Helper Test Job",
      description: "Test helpers",
      reward: 1500,
      status: "open",
      deadline: 1.week.from_now
    )

    feedback = Feedback.create!(
      job: job,
      user: client.user,
      rating: 5,
      comment: "Amazing",
      role: "client"
    )

    assert_equal developer, feedback.developer
    assert_equal client,    feedback.client
  end
end