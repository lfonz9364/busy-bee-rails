class UsersController < ApplicationController
  before_action :require_login
  before_action :set_user, only: %i[show edit update make_admin]
  before_action :authorise_user_access!, only: %i[show edit update]
  before_action :require_admin, only: %i[index make_admin]

  def index
    @users = User.order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def make_admin
    if @user == current_user
      redirect_to users_path, alert: "You are already managing your own access."
      return
    end

    if @user.admin?
      redirect_to users_path, alert: "#{@user.name} is already an admin"
      return
    end

    @user.update(admin: true)
    redirect_to users_path, notice: "#{@user.name} Admin role assigned successfully."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorise_user_access!
    return if current_user&.admin?
    return if current_user == @user

    redirect_to root_path, alert: "You are not authorised to access this profile."
  end

  def user_params
    params.require(:user).permit(
      :name, 
      :email, 
      :address, 
      :suburb, 
      :state, 
      :postcode, 
      :country, 
      :contact_person
    )
  end
end