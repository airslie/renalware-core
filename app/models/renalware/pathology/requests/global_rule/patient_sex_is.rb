require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PatientSexIs < GlobalRule
          def observation_required_for_patient?(patient)
            patient.sex.code == param_comparison_value
          end

          def to_s
            "patient is #{param_comparison_value}"
          end
        end
      end
    end
  end
end
