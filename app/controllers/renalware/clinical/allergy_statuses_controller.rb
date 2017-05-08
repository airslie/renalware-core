require_dependency "renalware/clinical"

module Renalware
  module Clinical
    class AllergyStatusesController < Clinical::BaseController

      def update
        authorize patient
        form = AllergyStatusForm.new(allergy_status_params)
        if form.save(patient, current_user)
          redirect_back fallback_location: patient_clinical_profile_path(patient),
                        notice: "Allergy status updated"
        else
          # we use client-side validation so will not get here
          raise NotImplementedError
        end
      end

      private

      def allergy_status_params
        params.require(:clinical_allergy_status_form).permit(:no_known_allergies)
      end
    end
  end
end
