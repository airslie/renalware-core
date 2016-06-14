require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      module_function

      def table_name_prefix
        "pathology_request_algorithm_"
      end
    end
  end
end
