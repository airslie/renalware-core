require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class RequestResult < Base
          VALID_OPERATORS = ["==", ">", "<", ">=", "<="].freeze

          def initialize(patient, param_id, param_comparison_operator, param_comparison_value)
            unless VALID_OPERATORS.include?(param_comparison_operator)
              raise ArgumentError
            end

            super(patient, param_id, param_comparison_operator, param_comparison_value)
          end

          def required?
            return true if observation_result.nil?
            observation_result.send(@param_comparison_operator.to_sym, @param_comparison_value.to_i)
          end

          def to_s
            "last result is #{@param_comparison_operator} #{@param_comparison_value}"
          end

          private

          def observation_result
            @observation_result ||= begin
              observation = find_observation_for_patient(observation_description)
              observation.result.to_i if observation.present?
            end
          end

          def find_observation_for_patient(observation_description)
            ::Renalware::Pathology::ObservationForPatientObservationDescriptionQuery.new(
              @patient, observation_description
            ).call
          end

          def observation_description
            @observation_description ||= find_request_description.required_observation_description
          end

          def find_request_description
            Renalware::Pathology::RequestDescription.find(@param_id)
          end
        end
      end
    end
  end
end
