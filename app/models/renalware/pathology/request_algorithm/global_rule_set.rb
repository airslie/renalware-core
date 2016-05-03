require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class GlobalRuleSet < ActiveRecord::Base
        include FrequencyMethods

        self.table_name = "pathology_request_algorithm_global_rule_sets"

        REGIMES = ["Nephrology", "LCC", "PD", "HD", "TP", "Donor Screen", "Donor Clinic"]
        FREQUENCIES = ["Always", "Once", "Weekly", "Monthly"]

        has_many :rules, class_name: "GlobalRule"
        belongs_to :observation_description

        validates :observation_description_id, presence: true
        validates :regime, presence: true, inclusion: { in: REGIMES }
        validates :frequency, presence: true, inclusion: { in: FREQUENCIES }

        def required_for_patient?(patient)
          last_observation =
            ObservationForPatientQuery.new(patient, observation_description_id).call

          return true if last_observation.nil?

          days_ago_observed = Date.today - last_observation.observed_at.to_date

          required_from_frequency?(frequency, days_ago_observed)
        end
      end
    end
  end
end
