require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class ObservationResult < GlobalRule
          def observation_required_for_patient?(patient)
            PatientGlobalRuleDecision.new(patient, self).observation_required_for_patient?
          end

          def to_s
            "#{observation_description.code} " \
            " #{param_comparison_operator} " \
            "#{param_comparison_value}"
          end

          def observation_description
            @observation_description ||=
              Renalware::Pathology::ObservationDescription.find(param_id)
          end
        end

        class PatientGlobalRuleDecision
          def initialize(patient, rule)
            @patient = patient
            @rule = rule
          end

          def observation_required_for_patient?
            return true if observation_result.nil?

            observation_result.send(
              @rule.param_comparison_operator.to_sym,
              @rule.param_comparison_value.to_i
            )
          end

          private

          def observation_result
            @observation_result ||= begin

              observation =
                ::Renalware::Pathology::ObservationForPatientObservationDescriptionQuery
                  .new(@patient, observation_description).call

              observation.result.to_i if observation.present?
            end
          end

          def observation_description
            @observation_description ||=
              Renalware::Pathology::ObservationDescription.new(id: @rule.param_id)
          end
        end
      end
    end
  end
end
