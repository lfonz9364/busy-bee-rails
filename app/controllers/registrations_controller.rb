class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params.except(:skillset))

    Rails.logger.debug "ROLE PARAM: #{registration_params[:role]}"
    Rails.logger.debug "USER ROLE BEFORE SAVE: #{@user.role}"
    if @user.save
      create_role_record!(@user)
      Rails.logger.debug "USER ROLE AFTER: #{@user.reload.role}"
      Rails.logger.debug "CLIENT? #{@user.client.present?}"
      Rails.logger.debug "DEVELOPER? #{@user.developer.present?}"
      # 🔥 FORCE consistency (important for CI)
      @user.update_column(:role, registration_params[:role])

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
      user.create_client!
    when "developer"
      user.create_developer!(skillset: registration_params[:skillset].to_s)
    else
      raise "Unknown role: #{user.role}"
    end
  end
end