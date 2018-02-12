require_dependency "renalware/medications"
require "collection_presenter"

module Renalware
  module Medications
    class SummaryPart < Renalware::SummaryPart
      def current_prescriptions
        @current_prescriptions ||= begin
          prescriptions = patient.prescriptions
                                 .includes(drug: [:drug_types, :classifications])
                                 .includes(:medication_route)
                                 .current
                                 .ordered
          CollectionPresenter.new(prescriptions, Medications::PrescriptionPresenter)
        end
      end

      def to_partial_path
        "renalware/medications/summary_part"
      end
    end
  end
end
