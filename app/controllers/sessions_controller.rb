class SessionsController < ApplicationController
  def new
    return unless logged_in?

    redirect_to role_based_root_path(current_user)
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      if user.archived?
        redirect_to login_path, alert: "Your account has been deleted. Please contact customer support to reactivate."
        return
      end

      reset_session
      session[:user_id] = user.id
      redirect_to(session.delete(:forwarding_url) || role_based_root_path(user), notice: "Logged in!")
    else
      flash.now[:alert] = "Email or password is invalid"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Logged out!"
  end

  private

  def role_based_root_path(user)
    return users_path if user.admin?
    return my_posted_jobs_path if user.client?
    return my_applications_path if user.developer?

    user_path(user)
  end
end