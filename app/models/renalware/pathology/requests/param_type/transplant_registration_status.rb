require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class TransplantRegistrationStatus
          def initialize(patient, _param_id, _param_comparison_operator, param_comparison_value)
            @patient = patient
            @status_code = param_comparison_value
          end

          def required?
            return false unless registration.present?

            registration_status.description.code == @status_code
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
