class PasswordResetMailer < ApplicationMailer
  def reset_email
    @user = params[:user]
    return if @user.blank?

    @reset_url = reset_password_url(@user.reset_password_token)
    mail(to: @user.email, subject: "Reset your Busy Bee account password")
  end
end
