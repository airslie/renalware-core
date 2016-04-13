require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Provides a stand-in for a pesenter
    class SimplePresenter
      attr_reader :view_model

      def present(results)
        @view_model = results
      end
    end
  end
end
