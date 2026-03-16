class UsersController < ApplicationController
  before_action :require_login
  before_action :require_admin, only: :index
  before_action :set_user, only: :show
  before_action only: :show do
    require_self_or_admin(@user)
  end
  def index
    @users = User.order(:name)
  end

  def show
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end