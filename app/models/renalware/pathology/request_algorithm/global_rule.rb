require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestAlgorithm
      class GlobalRule < ActiveRecord::Base
        self.table_name = "pathology_request_algorithm_global_rules"

        GROUPS = ["Nephrology", "LCC", "PD", "HD", "TP", "Donor Screen", "Donor Clinic"]

        validates :observation_description_id, presence: true
        validates :regime, presence: true, inclusion: { in: GROUPS }
      end
    end
  end
end
