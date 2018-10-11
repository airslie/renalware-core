# frozen_string_literal: true

require_dependency "renalware/low_clearance"

module Renalware
  module LowClearance
    class ProfilesController < BaseController
      def edit
        render_edit(find_and_authorize_profile)
      end

      def update
        profile = find_and_authorize_profile
        if profile.update_by(current_user, profile_params)
          redirect_to patient_low_clearance_dashboard_path,
                      notice: t(".success", model_name: "profile")
        else
          flash.now[:error] = failed_msg_for("profile")
          render_edit(profile)
        end
      end

      private

      def find_and_authorize_profile
        (patient.profile || patient.build_profile).tap do |profile|
          authorize profile
        end
      end

      def render_edit(profile)
        render :edit, locals: { patient: patient, profile: profile }
      end

      def profile_params
        params.require(:low_clearance_profile).permit(document: {})
      end
    end
  end
end
