class DevelopersController < ApplicationController
  before_action :set_developer, only: :show

  def index
    @developers = Developer.includes(:user)
  end

  def show
    # Feedbacks received by the developer
    @feedbacks = @developer.received_feedbacks
                           .includes(:user,:job)
                           .order(created_at: :desc)
  end

  private 

  def set_developer
    @developer = Developer.find(params[:id])
  end
end