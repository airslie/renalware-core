require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      module_function

      FREQUENCIES = ["Always", "Once", "Weekly", "Monthly"]

      def table_name_prefix
        "pathology_request_algorithm_"
      end
    end
  end
end
