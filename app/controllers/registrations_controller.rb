class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params.except(:skillset))

    if @user.save
      create_role_record!(@user)

      reset_session
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created successfully."
    else
      render :new, status: :unprocessable_entity
    end

  end

  private

  def registration_params
    params.require(:user).permit(
      :name,
      :email,
      :address,
      :suburb,
      :state,
      :postcode,
      :country,
      :contact_person,
      :abn,
      :password,
      :password_confirmation,
      :role,
      :skillset
    )
  end

  def create_role_record!(user)
    case user.role
    when "client"
      Client.create!(user: user)
    when "developer"
      Developer.create!(user: user, skillset: registration_params[:skillset])
    end
  end
end