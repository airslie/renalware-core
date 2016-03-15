require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationDescription < ActiveRecord::Base
      def to_s
        code
      end
    end
  end
end
