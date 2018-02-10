require_dependency "renalware/renal"
require "attr_extras"

module Renalware
  module Renal
    class ClinicalSummaryPresenter
      rattr_initialize :patient

      # Host application may override the order or add other summary presenters
      def summaries
        [
          Renalware::Problems::SummaryPart,
          Renalware::Medications::SummaryPart,
          Renalware::Letters::SummaryPart,
          Renalware::Events::SummaryPart,
          Renalware::Admissions::SummaryPart
        ]
      end
    end
  end
end
