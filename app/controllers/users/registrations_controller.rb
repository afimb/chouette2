class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  prepend_before_action :accept_user_creation, only: [:new, :create]

  def create
    super do
      resource.role = 2
      resource.save
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up).push(
      :name,
      :email,
      :password,
      :password_confirmation,
      organisation_attributes: [:name]
    )
  end

  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update).push(
      :name,
      :email,
      :password,
      :password_confirmation,
      :current_password
    )
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    organisation_user_path(resource)
  end

  private

  def accept_user_creation
    if !Rails.application.config.accept_user_creation
      redirect_to unauthenticated_root_path
      return false
    else
      return true
    end
  end
end
