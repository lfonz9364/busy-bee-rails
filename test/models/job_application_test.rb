require "test_helper"

class JobApplicationTest < ActiveSupport::TestCase
  test "is valid with job, developer, and default pending status" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    application = JobApplication.new(
      job: job,
      developer: developer,
      message: "I would love to work on this."
    )

    assert application.valid?
    assert_equal "pending", application.status
  end

  test "requires unique developer per job" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    JobApplication.create!(
      job: job,
      developer: developer,
      message: "First application"
    )

    duplicate = JobApplication.new(
      job: job,
      developer: developer,
      message: "Second application"
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:developer_id], "has already been taken"
  end

  test "reviewable_by_client? returns true for job owner client user" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    application = JobApplication.create!(
      job: job,
      developer: developer,
      message: "Please consider me"
    )

    assert application.reviewable_by_client?(client.user)
  end

  test "reviewable_by_client? returns false for non owner user" do
    client = create_client
    other_client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    application = JobApplication.create!(
      job: job,
      developer: developer,
      message: "Please consider me"
    )

    assert_not application.reviewable_by_client?(other_client.user)
  end

  test "expired? is false for recent pending application" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    application = JobApplication.create!(
      job: job,
      developer: developer,
      message: "Recent application"
    )

    assert_not application.expired?
  end

  test "expired? is true for pending application older than 5 business days" do
    client = create_client
    developer = create_developer
    job = create_job(client: client, developer: nil, status: "open")

    application = JobApplication.create!(
      job: job,
      developer: developer,
      message: "Old application",
      created_at: 10.days.ago
    )

    assert application.expired?
  end
end