class JobsController < ApplicationController
  before_action :require_login
  before_action :set_job, only: %i[show edit update destroy complete]
  before_action :require_client, only: %i[new create edit update destroy complete]
  before_action :authorise_client_job_edit!, only: %i[edit update destroy]
  before_action :authorise_client_job_completion!, only: %i[complete]

  def index
    @jobs = Job.includes(developer: :user, client: :user).order(created_at: :desc)

    if params[:query].present?
      q = "%#{params[:query]}%"
      @jobs = @jobs.where("title ILIKE ? OR description ILIKE ?", q, q)
    end
  end

  def show
    @feedbacks = @job.feedbacks.includes(:client).order(created_at: :desc)
    @client_feedback = current_user&.client == @job.client ? @job.feedbacks.find_by(user: current_user, role: "client") : nil
  end

  def new
    @job = Job.new
  end

  def create
    @job = current_user.client.jobs.build(job_params)

    if @job.save
      redirect_to @job, notices: "Job created succesfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @job.update(job_params)
      redirect_to @job, notice: "Job updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job.destroy
    redirect_to jobs_path, notice: "Job deleted succesfully"
  end

  def complete
    @job.mark_completed!
    redirect_to @job, notice: "Job marked as completed"
  end

  private 

  def set_job
    @job = Job.find(params[:id])
  end

  def authorise_client_job_edit!
    return if @job&.editable_by_client?(current_user)

    redirect_to @job, alert: "You are not allowed to modify a job if you are not the client or it is taken by a developer"
  end

  def authorise_client_job_completion!
    return if @job.completable_by_client?(current_user)

    redirect_to @job, alert: "You are not allowed to complete this job"
  end

  def job_params
    params.require(:job).permit(:title, :description, :reward, :status, :deadline)
  end
end