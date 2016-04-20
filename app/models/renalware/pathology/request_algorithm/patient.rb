require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestAlgorithm
      class Patient
        def initialize(patient)
          @patient = ::Renalware::Pathology.cast_patient(patient)
        end

        def required_pathology
          @patient.patient_rules.select { |rule| rule.required? }
        end
      end
    end
  end
end
