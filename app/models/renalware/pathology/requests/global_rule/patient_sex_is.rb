require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PatientSexIs < Base
          def required?
            @patient.sex.code == @param_comparison_value
          end

          def to_s
            "patient is #{@param_comparison_value}"
          end
        end
      end
    end
  end
end
