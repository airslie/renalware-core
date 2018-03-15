# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      module_function

      def table_name_prefix
        "pathology_requests_"
      end
    end
  end
end
