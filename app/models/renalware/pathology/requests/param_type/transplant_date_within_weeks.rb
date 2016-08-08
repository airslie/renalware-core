require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class TransplantDateWithinWeeks
          def initialize(patient, _param_id, _param_comparison_operator, param_comparison_value)
            @patient = patient
            @weeks_ago = param_comparison_value.to_i
          end

          def required?
            recipient_operation.performed_on > @weeks_ago.weeks.ago
          end

          private

          def recipient_operation
            @operations ||=
              Renalware::Transplants::RecipientOperation.for_patient(@patient).reversed.first
          end
        end
      end
    end
  end
end
