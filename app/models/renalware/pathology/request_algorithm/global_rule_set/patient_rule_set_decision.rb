module Renalware
  module Pathology
    module RequestAlgorithm
      class GlobalRuleSet
        class PatientRuleSetDecision
          include FrequencyMethods

          def initialize(patient, rule_set)
            @rule_set = rule_set
            @patient = patient
          end

          # NOTE: Decide if a rule_set applies to a patient
          def call
            today = Date.current

            return false if request_still_being_processed?(today)
            return false unless required_from_rules?
            required_from_last_observation?(today)
          end

          private

          def request_still_being_processed?(today)
            expiration_days = @rule_set.request_description.expiration_days

            return false if last_request.nil? || expiration_days.nil? || last_observation.present?

            days_ago_observed = today - last_request.requested_on
            days_ago_observed < expiration_days
          end

          def required_from_rules?
            @rule_set.rules
              .map { |rule| rule.required_for_patient?(@patient) }
              .all?
          end

          def required_from_last_observation?(today)
            if @rule_set.frequency == "Once" && last_request.present? && last_observation.nil?
              return false
            elsif last_observation.nil?
              return true
            end

            days_ago_observed = today - last_observation.observed_on

            frequency_model.exceeds?(days_ago_observed)
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

          def frequency_model
            "Renalware::Pathology::RequestAlgorithm::Frequency::#{@rule_set.frequency}".constantize
          end
        end
      end
    end
  end
end
