require_dependency "renalware/letters"

module Renalware
  module Letters
    class ClinicVisitEvent < DumbDelegator
      def to_s
        "Clinic Visit"
      end
    end
  end
end
