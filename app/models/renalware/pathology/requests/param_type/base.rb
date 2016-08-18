require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class Base
          def initialize(patient, param_id, param_comparison_operator, param_comparison_value)
            @patient = patient
            @param_id = param_id
            @param_comparison_operator = param_comparison_operator
            @param_comparison_value = param_comparison_value
          end

          def required?
            raise NotImplementedError
          end

          def to_s
            raise NotImplementedError
          end
        end
      end
    end
  end
end
