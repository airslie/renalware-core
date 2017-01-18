require_dependency "renalware/patients"

# Note this singular resource is for updating the patient.primary_care_physician.
# The plural resource in the same folder is for managing primary_care_physicians.
module Renalware
  module Patients
    class PrimaryCarePhysicianController < BaseController

      def edit
        authorize patient
        render_form
      end

      def update
        authorize patient
        if selected_pyhsician && patient.update(primary_care_physician: selected_pyhsician,
                                                by: current_user)
          redirect_to patient_path(patient), notice: "GP changed successfully"
        else
          flash[:error] = "The patient's GP was not changed"
          redirect_to patient_path(patient)
        end
      end

      private

      def render_form
        render :edit, locals: locals, layout: false
      end

      def locals
        {
          patient: patient,
          available_primary_care_physicians: available_primary_care_physicians
        }
      end

      def selected_pyhsician
        @selected_pyhsician ||= begin
          PrimaryCarePhysician.find_by(id: patient_params[:primary_care_physician_id])
        end
      end

      def patient_params
        params.require(:patient).permit(:primary_care_physician_id)
      end

      def available_primary_care_physicians
        pratice_id = params[:practice_id]
        return [] unless pratice_id
        Practice.find(pratice_id).primary_care_physicians.map do |physician|
          [physician.to_s, physician.id]
        end
      end
    end
  end
end
