require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class RequestResult < GlobalRule
          def observation_required_for_patient?(patient)
            observation =
              ObservationForPatientObservationDescriptionQuery.new(
                patient, observation_description
              ).call
            observation_result = observation.result.to_i if observation.present?

            return true if observation_result.nil?
            observation_result.send(param_comparison_operator.to_sym, param_comparison_value.to_i)
          end

          def to_s
            "last result is #{param_comparison_operator} #{param_comparison_value}"
          end

          private

          def observation_description
            request_description.required_observation_description
          end

          def request_description
            RequestDescription.find(param_id)
          end
        end
      end
    end
  end
end
