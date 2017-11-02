require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationPresenter < SimpleDelegator
      delegate :name, :code, to: :description, prefix: true, allow_nil: true
      delegate :measurement_unit, to: :description
      delegate :name, to: :measurement_unit, prefix: true

      def html_class
        description.to_s.downcase
      end
    end
  end
end
