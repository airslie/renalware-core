require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PatientIsDiabetic
          def initialize(patient, _param_id, _param_comparison_operator, param_comparison_value)
            @patient = patient
            @diabetic = param_comparison_value == "true"
          end

          def required?
            @patient.diabetic
          end
        end
      end
    end
  end
end
