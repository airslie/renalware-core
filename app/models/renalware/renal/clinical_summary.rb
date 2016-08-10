require_dependency "renalware/renal"

module Renalware
  module Renal
    class ClinicalSummary
      def initialize(patient)
        @patient = patient
      end

      def current_prescriptions
        @patient.prescriptions.current
      end
    end
  end
end
