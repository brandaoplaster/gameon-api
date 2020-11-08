class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if
  
  protected

  def configure_permitted_parameters
    devise_params_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
  end
end
