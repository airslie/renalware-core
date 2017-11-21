require_dependency "renalware/clinical"

module Renalware
  module Clinical
    class AllergiesController < Clinical::BaseController
      def create
        result = CreateAllergy.new(patient, current_user).call(allergy_params) do |allergy|
          authorize allergy
        end
        if result.success?
          redirect_back fallback_location: patient_clinical_profile_path(patient),
                        notice: success_msg_for("allergy")

        else
          # we use client-side validation so will not get here
          raise NotImplementedError
        end
      end

      def destroy
        allergy = patient.allergies.find(params[:id])
        authorize allergy
        DeleteAllergy.new(allergy, current_user).call
        redirect_back fallback_location: patient_clinical_profile_path(patient),
                      notice: t(".success_with_name", name: allergy.description)
      end

      private

      def allergy_params
        params.require(:clinical_allergy).permit([:description])
      end
    end
  end
end
