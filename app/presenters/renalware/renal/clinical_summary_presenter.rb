require_dependency "renalware/renal"
require "collection_presenter"

module Renalware
  module Renal
    class ClinicalSummaryPresenter
      def initialize(patient)
        @patient = patient
      end

      def current_prescriptions
       prescriptions = @patient.prescriptions.current.ordered
       CollectionPresenter.new(prescriptions, Medications::PrescriptionPresenter)
      end
    end
  end
end
