require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class TransplantDateWithinWeeks < Base
          def required?
            return false unless most_recent_operation.present?

            most_recent_operation.performed_on > required_weeks_ago
          end

          def to_s
            "transplant date within #{@param_comparison_value} weeks ago"
          end

          private

          def required_weeks_ago
            @param_comparison_value.to_i.weeks.ago
          end

          def most_recent_operation
            @most_recent_operation ||=
              Renalware::Transplants::RecipientOperation.for_patient(@patient).most_recent
          end
        end
      end
    end
  end
end
