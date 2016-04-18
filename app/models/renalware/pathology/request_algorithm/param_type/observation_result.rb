require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestAlgorithm
      module ParamType
        class ObservationResult
          def initialize(patient, param_id, param_comparison_operator, param_comparison_value)
            unless ["==", ">", "<", ">=", "<="].include?(param_comparison_operator)
              raise ArgumentError
            end

            @patient = Renalware::Pathology.cast_patient(patient)
            @param_id = param_id.to_i
            @param_comparison_operator = param_comparison_operator
            @param_comparison_value = param_comparison_value.to_i
          end

          def patient_requires_test?
            observation_result.send(@param_comparison_operator.to_sym, @param_comparison_value)
          end

          private

          def observation_result
            @observation_result ||=
              @patient.observations.where(description_id: @param_id).order(observed_at: :desc)
              .limit(1).first.result.to_i
          end
        end
      end
    end
  end
end
