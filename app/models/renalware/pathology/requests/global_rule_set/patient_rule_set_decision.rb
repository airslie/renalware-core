module Renalware
  module Pathology
    module Requests
      class GlobalRuleSet
        class PatientRuleSetDecision
          OBSERVATION_REQUIRED = true
          OBSERVATION_NOT_REQUIRED = false

          def initialize(patient, rule_set)
            @rule_set = rule_set
            @patient = patient
          end

          # NOTE: Decide if a rule_set applies to a patient
          def call
            date_today = Date.current

            if last_observation.present?
              return OBSERVATION_NOT_REQUIRED unless observation_required_from_frequency?(
                date_today,
                last_observation,
                @rule_set.frequency
              )
            end

            if last_request.present?
              return OBSERVATION_NOT_REQUIRED unless last_request_has_expired?(
                date_today,
                last_request,
                @rule_set.request_description.expiration_days
              )
            end

            required_from_rules?
          end

          private

          def observation_required_from_frequency?(date_today, last_observation, frequency)
            observed_days_ago = date_today - last_observation.observed_on
            frequency.observation_required?(observed_days_ago)
          end

          def last_request_has_expired?(date_today, last_request, expiration_days)
            requested_days_ago = date_today - last_request.requested_on
            requested_days_ago >= expiration_days
          end

          def required_from_rules?
            @rule_set.rules
              .map { |rule| rule.required_for_patient?(@patient) }
              .all?
          end

          def last_observation
            @last_observation ||=
              ObservationForPatientRequestDescriptionQuery.new(
                @patient,
                @rule_set.request_description
              ).call
          end

          def last_request
            @last_request ||=
              RequestForPatientRequestDescriptionQuery.new(
                @patient,
                @rule_set.request_description
              ).call
          end
        end
      end
    end
  end
end
