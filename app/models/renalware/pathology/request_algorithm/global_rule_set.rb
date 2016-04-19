require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestAlgorithm
      class GlobalRuleSet < ActiveRecord::Base
        self.table_name = "pathology_request_algorithm_global_rule_sets"

        REGIMES = ["Nephrology", "LCC", "PD", "HD", "TP", "Donor Screen", "Donor Clinic"]
        FREQUENCIES = ["Always", "Once", "Weekly", "Monthly"]

        has_many :rules, class_name: "GlobalRule"

        validates :observation_description_id, presence: true
        validates :regime, presence: true, inclusion: { in: REGIMES }
        validates :frequency, presence: true, inclusion: { in: FREQUENCIES }

        def required_for_patient?(patient)
          last_observation = get_last_observation_for_patient(patient)
          return true if last_observation.nil?

          days_ago_observed = Date.today - last_observation.observed_at.to_date

          # TODO: Implement other frequency types (3Monthly, Yearly etc.)
          if frequency == "Always"
            true
          elsif frequency == "Once"
            false
          elsif frequency == "Weekly"
            days_ago_observed >= 7
          elsif frequency == "Monthly"
            days_ago_observed >= 28
          end
        end

        private

        def get_last_observation_for_patient(patient)
          Renalware::Pathology.cast_patient(patient)
            .observations.where(description_id: observation_description_id)
            .order(observed_at: :desc).limit(1).first
        end
      end
    end
  end
end
