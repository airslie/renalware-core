require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationDescription < ApplicationRecord
      belongs_to :measurement_unit
      validates :display_order, uniqueness: { allow_nil: true }
      validates :display_order_letters, uniqueness: { allow_nil: true }

      def self.for(codes)
        ObservationDescriptionsByCodeQuery.new(codes: codes).call
      end

      def to_s
        code
      end
    end
  end
end
