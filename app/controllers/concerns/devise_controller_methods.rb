require 'active_support/concern'

module DeviseControllerMethods
  extend ActiveSupport::Concern

  included do
    class_eval do
      before_action :authenticate_user!
      before_action :configure_permitted_parameters, if: :devise_controller?
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :password, :remember_me) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
    end
  end
end
