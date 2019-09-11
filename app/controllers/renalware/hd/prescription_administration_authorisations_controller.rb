# frozen_string_literal: true

require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class PrescriptionAdministrationAuthorisationsController < BaseController
      skip_after_action :verify_authorized
      skip_after_action :verify_policy_scoped

      def create
        user = User.find(auth_params[:id])
        if user.valid_password?(auth_params[:password])
          render status: :ok, plain: user.auth_token
        else
          # head :bad_request
          head :unauthorized
        end
      end

      private

      def auth_params
        params.require(:user).permit(:id, :password)
      end
    end
  end
end
