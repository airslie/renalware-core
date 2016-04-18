require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestAlgorithm
      class GlobalRule < ActiveRecord::Base
        self.table_name = "pathology_request_algorithm_global_rules"

        REGIMES = ["Nephrology", "LCC", "PD", "HD", "TP", "Donor Screen", "Donor Clinic"]
        PARAM_COMPARISON_OPERATORS = ["==", ">", "<", ">=", "<=", "include?"]

        validates :observation_description_id, presence: true
        validates :regime, presence: true, inclusion: { in: REGIMES }
        validates :param_comparison_operator, inclusion:
          { in: PARAM_COMPARISON_OPERATORS, allow_nil: true }

        def has_param?
          param_type.present?
        end
      end
    end
  end
end
