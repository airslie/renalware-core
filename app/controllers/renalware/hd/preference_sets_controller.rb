module Renalware
  module HD
    class PreferenceSetsController < BaseController
      before_filter :load_patient
      before_filter :load_bookmark

      def edit
        @preference_set = PreferenceSet.for_patient(@patient).first_or_initialize
      end

      def update
        @preference_set = PreferenceSet.for_patient(@patient).first_or_initialize

        if @preference_set.update_attributes(preference_set_params)
          redirect_to patient_hd_dashboard_path(@patient),
            notice: t(".success", model_name: "HD preferences")
        else
          flash[:error] = t(".failed", model_name: "HD preferences")
          render :edit
        end
      end

      private

      def attributes
        [:schedule, :other_schedule, :hospital_unit_id, :entered_on, :notes]
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
