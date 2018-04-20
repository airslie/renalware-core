# frozen_string_literal: true

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
        if update_patient
          redirect_to patient_path(patient), notice: "GP changed successfully"
        else
          flash[:error] = "The patient's GP was not changed"
          redirect_to patient_path(patient)
        end
      end

      private

      def update_patient
        return false unless selected_pyhsician
        patient.update(primary_care_physician: selected_pyhsician,
                       practice_id: patient_params[:practice_id],
                       by: current_user)
      end

      def render_form
        render :edit, locals: locals, layout: false
      end

      def locals
        patient.practice_id = params[:practice_id]
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
        params.require(:patient).permit(:primary_care_physician_id, :practice_id)
      end

      # Every time a practice is selected from the autocomplete list in the Find GP modal
      # we re-render the edit form and inject the practice_id as a hidden field therein. This was
      # its available in a form submission in the #update action.
      # The practice_id in this method is supplied here as a query param by the JS that refreshes
      # the form when a practice is selected - it will be the same as that posted in the form when
      # saved, but at this stage its  ephemeral and just here to let us build the PCP list to
      # render in the form.
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
