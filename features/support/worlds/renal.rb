module World
  module Renal
    module Domain
      # @section commands
      #

      def review_clinical_summary(patient:)
        @clinical_summary = Renalware::Renal::ClinicalSummary.new(patient)
      end
    end
  end
end
