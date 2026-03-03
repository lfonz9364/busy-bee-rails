require "test_helper"

class JobTest < ActiveSupport::TestCase
  
  test "valid job is created successfully" do
    job = create_job
    assert job.persisted?
    assert_equal "Test Job", job.title
  end

  # Test use override job because create_job will throw error if title is nil, and we want to test that validation
  test "job requires title" do
    job = override_job(title: nil)
    assert_not job.valid?
    assert_includes job.errors[:title], "can't be blank"
  end

  test "job belongs to a client" do
    job = create_job
    assert_instance_of Client, job.client
  end

  test "job belongs to a developer" do
    job = create_job
    assert_instance_of Developer, job.developer
  end

  # This test ensures that a job can be created without a developer, which is important for the workflow where a client creates a job before it's assigned to a developer.
  test "job can exist without developer" do
    job = create_job(developer: nil)
    assert job.persisted?
  end

end