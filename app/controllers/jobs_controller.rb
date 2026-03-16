class JobsController < ApplicationController
  before_action :set_job, only: :show

  def index
    @jobs = Job.includes(:developer, :client)
  end

  def show
    @feedbacks = @job.feedbacks.includes(:client).order(created_at: :desc)
  end

  private 

  def set_job
    @job = Job.find(params[:id])
  end
end