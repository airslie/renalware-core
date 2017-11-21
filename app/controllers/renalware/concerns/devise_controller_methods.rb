require "active_support/concern"

module Renalware
  module Concerns::DeviseControllerMethods
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
        devise_parameter_sanitizer.permit(
          :sign_up,
          keys: [
            :given_name,
            :family_name,
            :username,
            :email,
            :password,
            :password_confirmation,
            :remember_me
          ]
        )
      end

      def configure_sign_in_parameters
        devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :password, :remember_me])
      end

      def configure_account_update_parameters
        devise_parameter_sanitizer.permit(
          :account_update,
          keys: [
              :given_name,
              :family_name,
              :username,
              :email,
              :password,
              :password_confirmation,
              :current_password,
              :professional_position,
              :signature
          ]
        )
      end
    end
  end
end
