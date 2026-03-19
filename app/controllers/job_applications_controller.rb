class JobApplicationsController < ApplicationController
  before_action :require_login
  before_action :require_developer, only: [:create]
  before_action :set_job, only: [:create]
  before_action :set_job_application, only: [:accept, :decline]
  before_action :require_client, only: [:accept, :decline]
  before_action :authorise_client_review!, only: [:accept, :decline]

  def create
    unless @job.open_for_applications?
      redirect_to @job, alert: "This job is not open for applications."
      return
    end

    @job_application = @job.job_applications.build(
      developer: current_user.developer,
      message: params.dig(:job_application, :message)
    )

    if @job_application.save
      redirect_to @job, notice: "Application submitted successfully."
    else
      redirect_to @job, alert: @job_application.errors.full_messages.to_sentence
    end
  end

  def accept
    if @job_application.job.taken?
      redirect_to @job_application.job, alert: "This job has already been assigned."
      return
    end

    JobApplication.transaction do
      @job_application.update!(status: "accepted", reviewed_at: Time.current)
      @job_application.job.update!(developer: @job_application.developer, status: "in_progress")

      @job_application.job.job_applications
                      .where.not(id: @job_application.id)
                      .pending
                      .update_all(status: "declined", reviewed_at: Time.current, updated_at: Time.current)
    end

    redirect_to @job_application.job, notice: "Application accepted."
  end

  def decline
    @job_application.update!(status: "declined", reviewed_at: Time.current)
    redirect_to @job_application.job, notice: "Application declined."
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end

  def set_job_application
    @job_application = JobApplication.find(params[:id])
  end

  def authorise_client_review!
    return if @job_application.reviewable_by_client?(current_user)

    redirect_to root_path, alert: "You are not allowed to review this application."
  end
end