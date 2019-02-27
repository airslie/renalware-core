# frozen_string_literal: true

require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class PreferenceSetsController < BaseController
      before_action :load_patient
      skip_after_action :verify_policy_scoped

      def edit
        preference_set = PreferenceSet.for_patient(patient).first_or_initialize
        render locals: { patient: patient, preference_set: preference_set }
      end

      def update
        preference_set = PreferenceSet.for_patient(patient).first_or_initialize

        if preference_set.update(preference_set_params)
          redirect_to patient_hd_dashboard_path(patient),
                      notice: success_msg_for("HD preferences")
        else
          flash.now[:error] = failed_msg_for("HD preferences")
          render :edit, locals: { patient: patient, preference_set: preference_set }
        end
      end

      private

      def attributes
        [
          :schedule_definition_id, :other_schedule,
          :hospital_unit_id, :entered_on, :notes
        ]
      end

      def preference_set_params
        params
          .require(:hd_preference_set)
          .permit(attributes)
          .merge(by: current_user)
      end
    end
  end
end
