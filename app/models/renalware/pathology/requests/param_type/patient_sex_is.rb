require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PatientSexIs
          def initialize(patient, _param_id, _param_comparison_operator, param_comparison_value)
            @patient = patient
            @sex = param_comparison_value
          end

          def required?
            @patient.sex.code == @sex
          end
        end
      end
    end
  end
end
