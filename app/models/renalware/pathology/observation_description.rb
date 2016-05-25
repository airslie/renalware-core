require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationDescription < ActiveRecord::Base
      def self.for(codes)
        ObservationDescriptionsByCodeQuery.new(codes: codes).call
      end

      def to_s
        code
      end
    end
  end
end
