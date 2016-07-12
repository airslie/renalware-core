require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class ProfilesController < BaseController
      before_filter :load_patient

      def show
        profile = Profile.for_patient(@patient).first
        @profile = ProfilePresenter.new(profile)
      end

      def edit
        profile = Profile.for_patient(@patient).first_or_initialize
        preference_set = PreferenceSet.for_patient(@patient).first_or_initialize
        @profile = ProfilePresenter.new(profile, preference_set: preference_set)
      end

      def update
        profile = Profile.for_patient(@patient).first_or_initialize
        preference_set = PreferenceSet.for_patient(@patient).first_or_initialize
        @profile = ProfilePresenter.new(profile, preference_set: preference_set)

        if @profile.update_attributes(profile_params)
          redirect_to patient_hd_dashboard_path(@patient),
            notice: t(".success", model_name: "HD profile")
        else
          flash[:error] = t(".failed", model_name: "HD profile")
          render :edit
        end
      end

      private

      def profile_params
        params
          .require(:hd_profile)
          .permit(attributes)
          .merge(document: document_attributes, by: current_user)
      end

      def attributes
        [
          :schedule, :other_schedule, :hospital_unit_id,
          :prescribed_time, :prescribed_on, :prescriber_id,
          :named_nurse_id, :transport_decider_id,
          document: []
        ]
      end

      def document_attributes
        params
          .require(:hd_profile)
          .fetch(:document, nil).try(:permit!)
      end
    end
  end
end
