require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      module GlobalRule
        class PatientIsDiabetic < Base
          def required?
            @patient.diabetic
          end

          def to_s
            if @param_comparison_value == "true"
              "patient is DM"
            else
              "patient is not DM"
            end
          end
        end
      end
    end
  end
end
