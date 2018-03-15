# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    class PatientListener
      def patient_modality_changed_to_death(patient:, modality:, actor:)
        TerminateAllPatientPrescriptions.call(patient: patient, by: actor)
      end
    end
  end
end
