require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class TransplantRegistrationStatus < Base
          def required?
            return false unless registration.present?

            registration_status.description.code == @param_comparison_value
          end

          def to_s
            "transplant registration status is #{@param_comparison_value}"
          end

          private

          def registration_status
            @registration_status ||= registration.current_status
          end

          def registration
            @registration ||= Renalware::Transplants::Registration.for_patient(@patient).first
          end
        end
      end
    end
  end
end
