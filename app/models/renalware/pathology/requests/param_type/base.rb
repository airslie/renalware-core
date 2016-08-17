require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class Base
          attr_reader :param_id, :param_comparison_operator, :param_comparison_value

          def initialize(patient, _param_id, _param_comparison_operator, param_comparison_value)
            @patient = patient
            @param_id = param_id
            @param_comparison_operator = param_comparison_operator
            @param_comparison_value = param_comparison_value
          end

          def required?
            raise NotImplementedError
          end
        end
      end
    end
  end
end
