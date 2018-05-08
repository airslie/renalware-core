# frozen_string_literal: true

require_dependency "renalware/patients"

# Note this singular resource is for updating the patient.primary_care_physician.
# The plural resource in the same folder is for managing primary_care_physicians.
module Renalware
  module Patients
    class PrimaryCarePhysicianController < BaseController
      # We come in here when
      # 1. We render the Add GP modal form the first time (html)
      # 2. After a practice has been selected and we refresh the modal form so it has
      #    the correct list of GPs in it (js)
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

      # There maybe times (for instance after migration from a previous system) where the
      # patient is not `valid` (going into Demographics and just saving them would produce a
      # validation error) because for instance they have no Sex option selected. In these instances
      # if we tried to update the Practice and GP here using an `update` call, it would fail.
      # So to allow the Practice and GP to be assigned to such a patient we have to skip validation
      # callbacks by using update_columns.
      def update_patient
        return false unless selected_pyhsician
        patient.update_columns(
          primary_care_physician_id: selected_pyhsician.id,
          practice_id: patient_params[:practice_id],
          updated_by_id: current_user.id
        )
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
