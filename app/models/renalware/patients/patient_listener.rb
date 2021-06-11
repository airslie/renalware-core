# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Patients
    class PatientListener
      def patient_modality_changed_to_death(args)
        ClearPatientUKRDCData.call(patient: args[:patient], by: args[:actor])
      end
    end
  end
end
