# frozen_string_literal: true

require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class CurrentProfileController < BaseController
      before_action :load_patient
      before_action :load_profile

      def show
        render :show, locals: locals
      end

      def edit
        render :edit, locals: locals
      end

      def update
        if update_profile
          redirect_to patient_hd_dashboard_path(patient),
                      notice: success_msg_for("HD profile")
        else
          flash.now[:error] = failed_msg_for("HD profile")
          render :edit, locals: locals
        end
      end

      private

      attr_reader :profile

      def locals
        { profile: profile_presenter, patient: patient }
      end

      def update_profile
        update_named_nurse_on_patient

        if profile.persisted?
          ReviseHDProfile.new(profile).call(profile_params)
        else
          profile.update(profile_params.merge(active: true))
        end
      end

      def update_named_nurse_on_patient
        patient.update!(
          named_nurse_id: profile_params[:named_nurse_id],
          by: current_user
        )
      end

      def preference_set
        PreferenceSet.for_patient(patient).first_or_initialize
      end

      def profile_presenter
        ProfilePresenter.new(profile, preference_set: preference_set)
      end

      def load_profile
        @profile = begin
          Profile
            .for_patient(patient)
            .first_or_initialize
            .tap { |profile| profile.named_nurse_id = patient.named_nurse_id }
        end
      end

      def profile_params
        params
          .require(:hd_profile)
          .permit(attributes)
          .to_h.merge(by: current_user)
      end

      # Note that named_nurse_id is a virtual attribute allowing us to update
      # patient.named_nurse using the hd profile form.
      def attributes
        [
          :schedule_definition_id, :other_schedule, :hospital_unit_id, :dialysate_id,
          :prescribed_time, :prescribed_on, :prescriber_id,
          :named_nurse_id, :transport_decider_id,
          document: {}
        ]
      end
    end
  end
end
