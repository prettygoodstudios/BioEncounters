class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) do |user|
        user.permit(:display, :email, :password, :password_confirmation)
      end
      devise_parameter_sanitizer.permit(:account_update) do |user|
        user.permit(:display, :email, :current_password)
      end
    end
end
