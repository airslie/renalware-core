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
      configure_sign_up_parameters
      configure_sign_in_parameters
      configure_account_update_parameters
    end

    def configure_sign_up_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :remember_me)
      end
    end

    def configure_sign_in_parameters
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :password, :remember_me) }
    end

    def configure_account_update_parameters
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:first_name, :last_name, :username, :email, :password,
                 :password_confirmation, :current_password, :professional_position)
      end
    end
  end
end
