require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class Patient
        def initialize(patient)
          @patient = patient
        end

        def determine_required_tests
          @patient.rules.select { |rule| rule.required? }
        end
      end
    end
  end
end
