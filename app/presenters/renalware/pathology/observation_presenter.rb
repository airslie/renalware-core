require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationPresenter < SimpleDelegator
      def html_class
        description.to_s.downcase
      end
    end
  end
end
