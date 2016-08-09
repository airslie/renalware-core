require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class TransplantDateWithinWeeks
          def initialize(patient, _param_id, _param_comparison_operator, param_comparison_value)
            @patient = patient
            @weeks_ago = param_comparison_value.to_i.weeks.ago
          end

          def required?
            return false unless most_recent_operation.present?

            most_recent_operation.performed_on > @weeks_ago
          end

          private

          def most_recent_operation
            @most_recent_operation ||=
              Renalware::Transplants::RecipientOperation.for_patient(@patient).most_recent
          end
        end
      end
    end
  end
end
