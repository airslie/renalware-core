require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class TransplantRegistrationStatus < GlobalRule
          def observation_required_for_patient?(patient)
            registration = Renalware::Transplants::Registration.for_patient(patient).first
            return false unless registration.present?

            registration_status = registration.current_status
            registration_status.description.code == param_comparison_value
          end

          def to_s
            "transplant registration status is #{@param_comparison_value}"
          end
        end
      end
    end
  end
end
