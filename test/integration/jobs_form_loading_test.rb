require "test_helper"

class JobsFormLoadingTest < ActionDispatch::IntegrationTest
  test "create job form renders loading text on submit button" do
    client = create_client
    sign_in_as(client)

    get new_job_path

    assert_response :success
    assert_select "input[type=submit][value='Create job'][data-loading-text='Creating job...']"
  end

  test "update job form renders loading text on submit button" do
    client = create_client

    job = create_job(client:, developer: nil)

    sign_in_as(client)

    get job_path(job)  

    get edit_job_path(job)

    assert_response :success
    assert_select "input[type=submit][value='Update job'][data-loading-text='Updating job...']"
  end

  test "applied job form renders loading text on submit button" do
    client = create_client
    developer = create_developer

    job = create_job(client:, developer: nil)

    sign_in_as(developer)

    get job_path(job)

    assert_response :success
    assert_select "input[type=submit][value='Apply now'][data-loading-text='Sending application...']"
  end
end