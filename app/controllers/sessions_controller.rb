class SessionsController < ApplicationController
  def new
    redirect_to jobs_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      reset_session
      session[:user_id] = user.id
      redirect_to(session.delete(:forwarding_url) || root_path, notice: "Logged in!")
    else
      flash.now[:alert] = "Email or password is invalid"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Logged out!"
  end
end