class FeedbacksController < ApplicationController
  before_action :require_login
  before_action :require_client, only: %i[new create edit update destroy]
  before_action :set_feedback, only: %i[show edit update destroy]
  before_action :authorize_feedback_edit!, only: %i[edit update destroy]

  def index
    @feedbacks = Feedback.includes(:job, :user).order(created_at: :desc)

    if params[:query].present?
      q = "%#{params[:query]}%"
      @feedbacks = @feedbacks.where("comment ILIKE ?", q)
    end
  end

  def show
  end

  def new
    @job = Job.find(params[:job_id])
    @feedback = @job.feedbacks.build
  end

  def create
    @job = Job.find(params[:job_id])
    @feedback = @job.feedbacks.build(feedback_params)
    @feedback.user = current_user
    @feedback.role = "client"

    if @feedback.editable_by_client?(current_user) || within_feedback_window_for_new?(@job)
      if @feedback.save
        redirect_to @job, notice: "Feedback created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to @job, alert: "Feedback can only be created within 30 days after the job deadline."
    end
  end

  def edit
  end

  def update
    if @feedback.update(feedback_params)
      redirect_to @feedback.job, notice: "Feedback updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @feedback.destroy
    redirect_to @feedback.job, notice: "Feedback deleted successfully."
  end

  private

  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  def authorize_feedback_edit!
    return if @feedback.editable_by_client?(current_user)

    redirect_to root_path, alert: "You are not allowed to modify this feedback."
  end

  def within_feedback_window_for_new?(job)
    current_user.client == job.client && Time.current <= (job.deadline + 30.days)
  end

  def feedback_params
    params.require(:feedback).permit(:rating, :comment)
  end
end