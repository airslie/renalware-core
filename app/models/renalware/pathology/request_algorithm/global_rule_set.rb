require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class GlobalRuleSet < ActiveRecord::Base
        include FrequencyMethods

        self.table_name = "pathology_request_algorithm_global_rule_sets"

        REGIMES = ["Nephrology", "LCC", "PD", "HD", "TP", "Donor Screen", "Donor Clinic"]

        has_many :rules, class_name: "GlobalRule"
        belongs_to :request_description

        validates :request_description, presence: true
        validates :regime, presence: true, inclusion: { in: REGIMES }
        validates :frequency, presence: true, inclusion: { in: FREQUENCIES }

        def required_for_patient?(patient)
          PatientDecisionQuery.new(self, patient).call
        end

        class PatientDecisionQuery
          include FrequencyMethods

          def initialize(rule_set, patient)
            @rule_set = rule_set
            @patient = patient
            @last_request = RequestForPatientRequestDescriptionQuery.new(
              Renalware::Pathology.cast_patient(patient),
              rule_set.request_description_id
            ).call
            @last_observation = ObservationForPatientRequestDescriptionQuery.new(
              Renalware::Pathology.cast_patient(patient),
              rule_set.request_description_id
            ).call
          end

          def call
            return false if request_still_being_processed?
            return false unless required_from_rules?
            required_from_last_observation?
          end

          private

          def request_still_being_processed?
            expiration_days = @rule_set.request_description.expiration_days

            return false if @last_request.nil? || expiration_days.nil? || @last_observation.present?

            days_ago_observed = Date.current - @last_request.requested_at.to_date
            days_ago_observed < expiration_days
          end

          def required_from_rules?
            @rule_set.rules
              .map { |rule| rule.required_for_patient?(@patient) }
              .all?
          end

          def required_from_last_observation?
            if @rule_set.frequency == 'Once' && @last_request.present? && @last_observation.nil?
              return false
            elsif @last_observation.nil?
              return true
            end

            days_ago_observed = Date.current - @last_observation.observed_at.to_date
            required_from_frequency?(@rule_set.frequency, days_ago_observed)
          end
        end
      end
    end
  end
end
