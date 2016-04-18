require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestAlgorithm
      module ParamType
        class Drug
          def initialize(patient, param_id, _param_comparison_operator, _param_comparison_value)
            @patient = patient
            @param_id = param_id.to_i
          end

          def patient_requires_test?
            @patient.drugs.count { |drug| drug.id == @param_id } > 0
          end
        end
      end
    end
  end
end
