class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email]&.downcase&.strip)

    user&.generate_password_reset_token!

    # Sending email
    PasswordResetMailer.with(user: user).reset_email.deliver_later if user.present?

    redirect_to login_path, notice: "You will receive email containing password reset link if your email registered"
  end

  def edit
    @user = User.find_by(reset_password_token: params[:token])

    if @user.blank? || @user.password_reset_expired?
      redirect_to forgot_password_path, alert: "Password reset link is invalid or has expired."
    end
  end

  def update
    @user = User.find_by(reset_password_token: params[:token])

    if @user.blank? || @user.password_reset_expired?
      redirect_to forgot_password_path, alert: "Password reset link has expired, please generate a new one"
      return
    end

    if params[:user][:password].blank?
      @user.errors.add(:password, "can't be blank")
      render :edit, status: :unprocessable_entity
      return
    end

    if @user.update(password_reset_params)
      @user.clear_password_reset_token!
      redirect_to login_path, notice: "Your password has been reset succesfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end