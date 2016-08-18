require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PatientIsDiabetic < GlobalRule
          def observation_required_for_patient?(patient)
            patient.diabetic == param_comparison_boolean
          end

          def to_s
            if param_comparison_boolean
              "patient is DM"
            else
              "patient is not DM"
            end
          end

          def param_comparison_boolean
            param_comparison_value == "true"
          end
        end
      end
    end
  end
end
