# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Patients
    class PatientListener
      def patient_modality_changed_to_death(patient:, actor:, **)
        ClearPatientUKRDCData.call(patient: patient, by: actor)
      end
    end
  end
end
