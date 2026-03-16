class DevelopersController < ApplicationController
  before_action :set_developer, only: :show

  def index
    @developers = Developer.includes(:user)
  end

  def show
    @average_rating = average_rating
    
    # Feedbacks received by the developer
    @feedbacks = @developer.received_feedbacks
                           .includes(:user,:job)
                           .order(created_at: :desc)
  end

  private 

  def set_developer
    @developer = Developer.find(params[:id])
  end

  def average_rating
    return 0 if @developer.received_feedbacks.empty?

    @developer.received_feedbacks.average(:rating).to_f.round(2)
  end
end