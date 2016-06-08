require_dependency "renalware/renal"
require_dependency "renalware/renal/base_controller"

module Renalware
  module Renal
    class ProfilesController < BaseController

      before_action :load_patient

      def edit
        @profile = find_profile
      end

      def update
        @profile = find_profile

        if @profile.update_attributes(profile_params)
          redirect_to patient_clinical_summary_path(@patient),
            notice: t(".success", model_name: "profile")
        else
          render :edit
        end
      end

      private

      def profile_params
        params
          .require(:renal_profile)
          .permit(:diagnosed_on, :prd_description_id, address_at_diagnosis_attributes: address_params)
      end

      def address_params
        [:name, :organisation_name, :street_1, :street_2, :county, :country, :city, :postcode]
      end

      def find_profile
        @patient.profile || @patient.build_profile
      end
    end
  end
end
