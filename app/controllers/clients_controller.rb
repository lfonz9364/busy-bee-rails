class ClientsController < ApplicationController
  before_action :set_client, only: :show

  def index
    @clients = Client.includes(:user)
  end

  def show
    @feedbacks = @client.authored_feedbacks
                        .includes(:job)
                        .order(created_at: :desc)
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end
end