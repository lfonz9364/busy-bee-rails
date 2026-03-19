require "test_helper"

class ExpireJobApplicationsTest < ActiveSupport::TestCase
  test "auto declines expired pending applications" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    application = JobApplication.create!(
      job: job,
      developer: developer,
      message: "Old pending application",
      created_at: 10.days.ago
    )

    ExpireJobApplications.call

    assert_equal "auto_declined", application.reload.status
    assert_not_nil application.reviewed_at
  end

  test "does not change recent pending applications" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    application = JobApplication.create!(
      job: job,
      developer: developer,
      message: "Recent pending application"
    )

    ExpireJobApplications.call

    assert_equal "pending", application.reload.status
  end
end