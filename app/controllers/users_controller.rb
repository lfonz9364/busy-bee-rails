class UsersController < ApplicationController
  before_action :require_login
  before_action :set_user, only: %i[show edit update]
  before_action :require_admin, only: %i[index make_admin]
  before_action only: %i[show edit update] do
    require_admin_or_self(@user)
  end

  def index
    @users = User.order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    permitted = current_user.admin? ? admin_user_params : user_params

    if @user.update(permitted)
      redirect_to @user, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def make_admin
    user = User.find(params[:id])
    user.update(admin: true)
    redirect_to users_path, notice: "Admin role assigned successfully."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :address, :suburb, :state, :postcode, :country, :contact_person)
  end

  def admin_user_params
    params.require(:user).permit(:name, :email, :address, :suburb, :state, :postcode, :country, :contact_person, :admin)
  end
end