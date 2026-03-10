class JobsController < ApplicationController
  before_action :set_job, only: :show

  def index
    @jobs = Job.includes(:developer, :user)
  end

  def show
    @feedbacks = @job.feedbacks.includes(:user).order(created_at: :desc)
  end

  private 

  def set_job
    @job = Job.find(params[:id])
  end
end