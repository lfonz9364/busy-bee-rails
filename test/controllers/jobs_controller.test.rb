require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    create_job
    get jobs_url
    
    assert_response :success
  end

  test "should show job with title" do
    job = create_job

    get job_url(job)
    
    assert_response :success
    assert_match job.title, @response.body
  end

  test "should show job details" do
    job = create_job

    get job_url(job)

    assert_response :success
    assert_match job.description, @response.body
    assert_match job.status, @response.body
  end
end