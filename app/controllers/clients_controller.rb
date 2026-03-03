class ClientsController < ApplicationController
  before_action :set_client, only: [:show]

  def index
    @clients = Client.includes(:user)
    render plain: "OK"
  end

  def show
    @feedbacks = @client.authored_feedbacks
                        .includes(:user,:job)
                        .order(created_at: :desc)

    render plain: "OK"
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end
end