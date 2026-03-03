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
end