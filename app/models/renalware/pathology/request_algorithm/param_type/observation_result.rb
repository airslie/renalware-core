require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
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
            return true if observation_result.nil?
            observation_result.send(@param_comparison_operator.to_sym, @param_comparison_value)
          end

          private

          def observation_result
            @observation_result ||= begin
              observation = @patient.observations.where(description_id: @param_id)
                .order(observed_at: :desc).limit(1).first

              observation.result.to_i if observation.present?
            end
          end
        end
      end
    end
  end
end
