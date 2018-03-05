# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationPresenter < SimpleDelegator
      delegate :name, :code, :loinc_code, to: :description, prefix: true, allow_nil: true
      delegate :measurement_unit, to: :description, allow_nil: true
      delegate :name, to: :measurement_unit, prefix: true, allow_nil: true

      def html_class
        description.to_s.downcase
      end
    end
  end
end
