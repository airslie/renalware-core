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
          redirect_to edit_patient_renal_profile_path(@patient),
            notice: t(".success", model_name: "profile")
        else
          render :edit
        end
      end

      private

      def profile_params
        params
          .require(:renal_profile)
          .permit(
            :esrf_on, :first_seen_on, :prd_description_id,
            :weight_at_esrf, :smoking_status, :comorbidities_updated_on,
            address_at_diagnosis_attributes: address_params
          )
          .merge(document: document_attributes)
      end

      def address_params
        [:name, :organisation_name, :street_1, :street_2, :county, :country, :city, :postcode]
      end

      def find_profile
        @patient.profile || @patient.build_profile
      end

      def document_attributes
        params
          .require(:renal_profile)
          .fetch(:document, nil)
          .try(:permit!)
      end
    end
  end
end
