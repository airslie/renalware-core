require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class TransplantDateWithinWeeks < GlobalRule
          def observation_required_for_patient?(patient)
            most_recent_operation =
              Renalware::Transplants::RecipientOperation.for_patient(patient).most_recent
            return false unless most_recent_operation.present?

            most_recent_operation.performed_on > required_weeks_ago
          end

          def to_s
            "transplant date within #{@param_comparison_value} weeks ago"
          end

          private

          def required_weeks_ago
            param_comparison_value.to_i.weeks.ago
          end
        end
      end
    end
  end
end
