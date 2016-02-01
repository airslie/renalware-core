module Renalware
  module Hd
    class PreferenceSetsController < BaseController
      before_filter :load_patient

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

      def preference_set_params
        params.require(:hd_preference_set).permit(:schedule, :other_schedule)
      end
    end
  end
end
