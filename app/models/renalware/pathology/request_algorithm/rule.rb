require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestAlgorithm
      class Rule < ActiveRecord::Base
        self.table_name = "pathology_request_algorithm_rules"

        GROUPS = ["Nephrology", "LCC", "PD", "HD", "TP", "Donor Screen", "Donor Clinic"]

        validates :request, presence: true
        validates :group, presence: true, inclusion: { in: GROUPS }
      end
    end
  end
end
