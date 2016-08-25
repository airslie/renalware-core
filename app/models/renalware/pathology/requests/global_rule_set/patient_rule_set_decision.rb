module Renalware
  module Pathology
    module Requests
      class GlobalRuleSet
        class PatientRuleSetDecision
          OBSERVATION_REQUIRED = true
          OBSERVATION_NOT_REQUIRED = false

          def initialize(patient, rule_set, date)
            @rule_set = rule_set
            @patient = patient
            @date = date
          end

          # NOTE: Decide if a rule_set applies to a patient
          def call
            return OBSERVATION_NOT_REQUIRED if last_observation_too_recent?
            return OBSERVATION_NOT_REQUIRED if last_request_still_being_processed?

            if required_from_rules?
              OBSERVATION_REQUIRED
            else
              OBSERVATION_NOT_REQUIRED
            end
          end

          private

          def last_observation_too_recent?
            return false if last_observation.nil?

            observed_days_ago = @date - last_observation.observed_on
            !@rule_set.frequency.observation_required?(observed_days_ago)
          end

          def last_request_still_being_processed?
            return false if last_request.nil? || last_request_has_an_observation_result?

            expiration_days = @rule_set.request_description.expiration_days
            return false if expiration_days == 0

            requested_days_ago = @date - last_request.requested_on
            requested_days_ago < expiration_days
          end

          def required_from_rules?
            @rule_set
              .rules
              .map { |rule| rule.observation_required_for_patient?(@patient, @date) }
              .all?
          end

          def last_request_has_an_observation_result?
            last_observation.present? &&
              last_observation.observed_on > last_request.requested_on
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
